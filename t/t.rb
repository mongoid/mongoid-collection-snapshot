require 'mongoid'
require 'mongoid-collection-snapshot'

puts ""

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
        puts "inserted #{widget.id} x #{gadget.id} into #{collection_snapshot.name}"
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

w = Widget.create!
puts "created widget #{w._id}"
g = Gadget.create!
puts "created gadget #{g._id}"

WidgetsAndGadgets.each.map(&:collection_snapshot).map(&:drop)

3.times do
  WidgetsAndGadgets.create!
end

require 'thread'

workers = (0...8).map do
  Thread.new do
    WidgetsAndGadgets.latest.documents.each do |pair|
      if pair.widget && pair.gadget
        puts "got a widget and gadget in #{pair.widget_id} x #{pair.gadget_id}"
      else
        raise "got a nil widget in #{pair.widget_id} x #{pair.gadget_id}"
      end
    end
  end
end

workers.map(&:join)

puts " done."
