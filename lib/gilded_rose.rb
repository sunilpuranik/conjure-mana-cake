class GildedRose
  attr_accessor :name, :days_remaining, :quality

  C_MAP = {
      "Normal Item" => 'NormalItem',
      "Aged Brie" => 'AgedBrie',
      "Sulfuras, Hand of Ragnaros" => 'Sulfuras',
      "Backstage passes to a TAFKAL80ETC concert" => 'BackStagePass',
      "Conjured Mana Cake" => 'ConjuredManaCake'
  }

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
    extend Object.const_get(C_MAP[@name])
  rescue TypeError => e
    raise ArgumentError.new("#{@name} is not a valid type")
  end

end


module NormalItem
  MIN_QUALITY = 0; MAX_QUALITY = 50; QUALITY_FACTOR = 1;

  def tick
    change_quality()
    change_expiry()
  end

  def change_quality
    @quality -= QUALITY_FACTOR
    @quality -= QUALITY_FACTOR if @days_remaining <= 0
    @quality = MIN_QUALITY if @quality < MIN_QUALITY
    @quality = MAX_QUALITY if @quality > MAX_QUALITY
  end

  def change_expiry
    @days_remaining -= 1
  end

  def sold?
    @days_remaining <= 0
  end

  def selling_really_soon?
    @days_remaining.between?(1,5)
  end

  def selling_soon?
    @days_remaining.between?(6,10)
  end

  def lot_days_to_sell?
    @days_remaining.between?(11,Float::INFINITY)
  end

end

module AgedBrie
  include NormalItem
  MAX_QUALITY = 50; QUALITY_FACTOR = 1;

  def change_quality
    @quality += 1
    @quality += 1 if sold?
    @quality = MAX_QUALITY if @quality > MAX_QUALITY
  end
end

module ConjuredManaCake
  include NormalItem
  MIN_QUALITY = 0; MAX_QUALITY = 50; QUALITY_FACTOR = 2;

  def change_quality
    @quality -= QUALITY_FACTOR
    @quality -= QUALITY_FACTOR if @days_remaining <= 0
    @quality = MIN_QUALITY if @quality < MIN_QUALITY
  end
end

module BackStagePass
  include NormalItem
  MAX_QUALITY = 50; QUALITY_FACTOR = 1;

  def change_quality
    case
    when lot_days_to_sell?
      @quality += (1 * QUALITY_FACTOR)
    when selling_soon?
      @quality += (2 * QUALITY_FACTOR)
    when selling_really_soon?
      @quality += (3 * QUALITY_FACTOR)
    else
      @quality = 0
    end
    # Reset to max quality
    @quality = MAX_QUALITY if @quality > MAX_QUALITY
  end
end

module Sulfuras
  include NormalItem
  def tick
    ## Dont change anything
  end
end