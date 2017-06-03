require 'spec_helper'

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
    collection_snapshot.drop
    Widget.all.each do |widget|
      Gadget.all.each do |gadget|
        if Mongoid::Compatibility::Version.mongoid5? || Mongoid::Compatibility::Version.mongoid6?
          collection_snapshot.insert_one(widget_id: widget.id, gadget_id: gadget.id)
        else
          collection_snapshot.insert(widget_id: widget.id, gadget_id: gadget.id)
        end
      end
    end
  end

  def snapshot_session
    if Mongoid::Compatibility::Version.mongoid5? || Mongoid::Compatibility::Version.mongoid6?
      Mongoid.client('imports')
    else
      Mongoid.session('imports')
    end
  end
end

module Mongoid
  describe CollectionSnapshot do
    before do
      Widget.delete_all
      Gadget.delete_all
      Widget.create!
      Gadget.create!
      WidgetsAndGadgets.each.map(&:collection_snapshot).each(&:drop)
      WidgetsAndGadgets.create!
    end
    it 'uses the correct database on a separate thread' do
      expect(WidgetsAndGadgets.latest.documents.count).to eq 1
      require 'thread'
      Thread.new do
        expect(WidgetsAndGadgets.latest.documents.count).to eq 1
        WidgetsAndGadgets.latest.documents.each do |pair|
          expect(pair.widget).to_not be nil
          expect(pair.gadget).to_not be nil
        end
      end.join
    end
  end
end
