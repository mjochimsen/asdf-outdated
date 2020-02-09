require "./spec_helper"

alias Version = Outdated::Version

describe Version do
  it "parses a four element version string" do
    version = Version.parse?("1.2.3.4")
    version.should_not be_nil
    unless version.nil?
      version.major.should eq 1
      version.minor.should eq 2
      version.micro.should eq 3
      version.nano.should eq 4
    end
  end

  it "parses a three element version string" do
    version = Version.parse?("1.2.3")
    version.should_not be_nil
    unless version.nil?
      version.major.should eq 1
      version.minor.should eq 2
      version.micro.should eq 3
      version.nano.should be_nil
    end
  end

  it "parses a two element version string" do
    version = Version.parse?("1.2")
    version.should_not be_nil
    unless version.nil?
      version.major.should eq 1
      version.minor.should eq 2
      version.micro.should be_nil
      version.nano.should be_nil
    end
  end

  it "parses a one element version string" do
    version = Version.parse?("1")
    version.should_not be_nil
    unless version.nil?
      version.major.should eq 1
      version.minor.should be_nil
      version.micro.should be_nil
      version.nano.should be_nil
    end
  end

  it "doesn't parse an invalid version string" do
    Version.parse?("alt-1.2").should be_nil
    Version.parse?("1.2-beta").should be_nil
    Version.parse?("1.2-0").should be_nil
    Version.parse?("nightly").should be_nil
    Version.parse?("").should be_nil
    Version.parse?("1..2").should be_nil
    Version.parse?(".1").should be_nil
    Version.parse?("1.").should be_nil
    Version.parse?("70000").should be_nil
  end

  it "compares versions" do
    v_1 = Version.new(1)
    v_1_2 = Version.new(1, 2)
    v_1_2_1 = Version.new(1, 2, 1)
    v_1_3 = Version.new(1, 3)
    v_1_10 = Version.new(1, 10)

    (v_1 <=> v_1).should eq 0
    (v_1 == v_1).should be_true

    (v_1_2 <=> v_1_3).should eq -1
    (v_1_2 < v_1_3).should be_true
    (v_1_3 <=> v_1_2).should eq 1
    (v_1_3 > v_1_2).should be_true

    (v_1_3 <=> v_1_10).should eq -1
    (v_1_3 < v_1_10).should be_true
    (v_1_10 <=> v_1_3).should eq 1
    (v_1_10 > v_1_3).should be_true

    (v_1_2 <=> v_1_2_1).should eq -1
    (v_1_2 < v_1_2_1).should be_true
    (v_1_2_1 <=> v_1_2).should eq 1
    (v_1_2_1 > v_1_2).should be_true
  end

  it "converts to an array" do
    Version.new(1, 2, 3, 4).to_a.should eq [1, 2, 3, 4]
    Version.new(1, 2, 3).to_a.should eq [1, 2, 3, nil]
    Version.new(1, 2).to_a.should eq [1, 2, nil, nil]
    Version.new(1).to_a.should eq [1, nil, nil, nil]
  end

  it "convert to a 64-bit unsigned integer" do
    Version.new(1, 2, 3, 4).to_u64.should eq 0x0001000200030004
    Version.new(1, 2, 3).to_u64.should eq 0x0001000200030000
    Version.new(1, 2).to_u64.should eq 0x0001000200000000
    Version.new(1).to_u64.should eq 0x0001000000000000
  end

  it "converts to a string" do
    Version.new(1, 2, 3, 4).to_s.should eq "1.2.3.4"
    Version.new(1, 2, 3).to_s.should eq "1.2.3"
    Version.new(1, 2).to_s.should eq "1.2"
    Version.new(1).to_s.should eq "1"
  end

  it "can compute the distance to another version" do
    v_1 = Version.new(1)
    v_1_2 = Version.new(1, 2)
    v_1_2_1 = Version.new(1, 2, 1)
    v_1_3 = Version.new(1, 3)

    v_1_2.distance(v_1_3).should eq 0x0000000100000000
    v_1_3.distance(v_1_2).should eq 0x0000000100000000
    v_1.distance(v_1_2_1).should eq 0x0000000200010000
    v_1_2_1.distance(v_1).should eq 0x0000000200010000
  end
end
