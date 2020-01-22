require File.expand_path('../../spec_helper', __FILE__)

describe Geo::Coord::Globes::Earth do
  before{
    @washington_dc = Geo::Coord.new(38.898748, -77.037684)
    @chicago = Geo::Coord.new(41.85, -87.65)
    @anti_washington = Geo::Coord.new(-38.898748, 102.962316)
  }

  it 'calculates distance (by Vincenty formula)' do
    @washington_dc.distance(@washington_dc).should == 0
    @washington_dc.distance(@chicago).should \
      be_within(1).of(@chicago.distance(@washington_dc))
    @washington_dc.distance(@chicago).should be_within(1).of(958183)

    # vincenty by design fails on antipodal points
    @washington_dc.distance(@anti_washington).should be_within(1).of(20037502)
  end

  it 'calculates azimuth' do
    # same point
    @washington_dc.azimuth(@washington_dc).should == 0

    # straight angles:
    Geo::Coord.new(41, -75).azimuth(Geo::Coord.new(39, -75)).should \
      be_within(1).of(180)

    Geo::Coord.new(40, -74).azimuth(Geo::Coord.new(40, -76)).should \
      be_within(1).of(270)

    Geo::Coord.new(39, -75).azimuth(Geo::Coord.new(41, -75)).should \
      be_within(1).of(0)

    Geo::Coord.new(40, -76).azimuth(Geo::Coord.new(40, -74)).should \
      be_within(1).of(90)

    # some direction on map
    @washington_dc.azimuth(@chicago).should be_within(1).of(293)

    # vincenty by design fails on antipodal points
    @washington_dc.azimuth(@anti_washington).should be_within(1).of(90)
  end

  it 'calculates endpoint' do
    d = @washington_dc.distance(@chicago)
    a = @washington_dc.azimuth(@chicago)

    endpoint = @washington_dc.endpoint(d, a)
    endpoint.should == @chicago
  end
end
