require 'mongoid'
require 'mongoid-collection-snapshot'

Mongoid.load!("mongoid.yml", :production)
Mongo::Logger.logger = Mongoid.logger = Logger.new('mongo.log', Logger::DEBUG)

class Widget
  include Mongoid::Document
end

class Gadget
  include Mongoid::Document
end

class WidgetsAndGadgets
  include Mongoid::CollectionSnapshot

  document do
    belongs_to :widget, inverse_of: nil
    belongs_to :gadget, inverse_of: nil
  end

  def build
    Widget.all.each do |widget|
      Gadget.all.each do |gadget|
        next unless Random.rand(2) == 1
        collection_snapshot.insert_one(widget_id: widget.id, gadget_id: gadget.id)
      end
    end
  end

  def snapshot_session
    Mongoid.client('imports')
  end
end

Widget.delete_all
Gadget.delete_all

Widget.create!
Gadget.create!

WidgetsAndGadgets.create!

require 'thread'

workers = (0...32).map do
  Thread.new do
    STDOUT.write "."
    WidgetsAndGadgets.latest.documents.each do |pair|
      raise "got a nil widget" unless pair.widget
      raise "got a nil gadget" unless pair.gadget
    end
  end
end

workers.map(&:join)

puts " done."
