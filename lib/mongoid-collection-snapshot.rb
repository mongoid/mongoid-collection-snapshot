require 'mongoid-collection-snapshot/version'

module Mongoid
  module CollectionSnapshot
    extend ::ActiveSupport::Concern

    DEFAULT_COLLECTION_KEY_NAME = '*'.freeze

    included do
      require 'mongoid_slug'

      include Mongoid::Document
      include Mongoid::Timestamps::Created
      include Mongoid::Slug

      field :workspace_basename, default: 'snapshot'
      slug :workspace_basename

      class_attribute :max_collection_snapshot_instances

      before_create :build
      after_create :ensure_at_most_max_instances_exist
      before_destroy :drop_snapshot_collections

      class_attribute :document_blocks
      class_attribute :document_classes

      # Mongoid documents on this snapshot.
      def documents(name = nil)
        self.class.document_classes ||= {}
        class_name = "#{self.class.name}#{id}#{name}".underscore.camelize
        key = "#{class_name}-#{name || DEFAULT_COLLECTION_KEY_NAME}"
        self.class.document_classes[key] ||= begin
          document_block = document_blocks[name || DEFAULT_COLLECTION_KEY_NAME] if document_blocks
          collection_name = collection_snapshot(name).name
          klass = Class.new do
            include Mongoid::Document
            if Mongoid::Compatibility::Version.mongoid5?
              cattr_accessor :mongo_client
            else
              cattr_accessor :mongo_session
            end
            instance_eval(&document_block) if document_block
          end
          if Mongoid::Compatibility::Version.mongoid6_or_newer?
            # assign a name to the snapshot session
            session_id = snapshot_session.object_id.to_s
            Mongoid::Clients.set session_id, snapshot_session
            # tell the class to use the client by name
            klass.class_variable_set :@@storage_options, client: session_id, collection: collection_name
          elsif Mongoid::Compatibility::Version.mongoid5?
            klass.store_in collection: collection_name
            klass.mongo_client = snapshot_session
          else
            klass.store_in collection: collection_name
            klass.mongo_session = snapshot_session
          end
          Object.const_set(class_name, klass)
          klass
        end
      end
    end

    module ClassMethods
      def latest
        order_by([[:created_at, :desc]]).first
      end

      def document(name = nil, &block)
        self.document_blocks ||= {}
        self.document_blocks[name || DEFAULT_COLLECTION_KEY_NAME] = block
      end
    end

    def collection_snapshot(name = nil)
      if name
        snapshot_session["#{collection.name}.#{name}.#{slug}"]
      else
        snapshot_session["#{collection.name}.#{slug}"]
      end
    end

    def drop_snapshot_collections
      collections = Mongoid::Compatibility::Version.mongoid5_or_newer? ? snapshot_session.database.collections : snapshot_session.collections
      collections.each do |collection|
        collection.drop if collection.name =~ /^#{self.collection.name}\.([^\.]+\.)?#{slug}$/
      end
    end

    # Since we should always be using the latest instance of this class, this method is
    # called after each save - making sure only at most two instances exists should be
    # sufficient to ensure that this data can be rebuilt live without corrupting any
    # existing computations that might have a handle to the previous "latest" instance.
    def ensure_at_most_max_instances_exist
      all_instances = self.class.order_by([[:created_at, :desc]]).to_a
      max_collection_snapshot_instances = self.class.max_collection_snapshot_instances || 2
      return unless all_instances.length > max_collection_snapshot_instances
      all_instances[max_collection_snapshot_instances..-1].each(&:destroy)
    end

    # Override to supply custom database connection for snapshots
    def snapshot_session
      Mongoid::Compatibility::Version.mongoid5_or_newer? ? Mongoid.default_client : Mongoid.default_session
    end
  end
end
