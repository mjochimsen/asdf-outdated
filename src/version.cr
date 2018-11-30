# A `Outdated::Version` describes a version number with `#major`,
# `#minor`, `#micro`, and `#nano` components. Components beyond the
# `#major` number may be `nil`.
struct Outdated::Version
  getter major : Int32
  getter minor : Int32?
  getter micro : Int32?
  getter nano : Int32?

  include Comparable(Version)

  # Create a new `Outdated::Version` struct. The *major* number must not
  # be `nil`, but the other components may be.
  def initialize(@major, @minor = nil, @micro = nil, @nano = nil)
  end

  # Parse a string into a `Outdated::Version` structure. If the *version*
  # string is not a valid version string, then `nil` is returned.
  #
  # ```
  # version = Outdated::Version.parse?("1.2.3")
  # version.major # => 1
  # version.minor # => 2
  # version.micro # => 3
  # version.nano # => nil
  #
  # Outdated::Version.parse?("1.2-beta") => nil
  # ```
  def self.parse?(version) : Version?
    return nil unless version =~ /^[0-9.]+$/
    parts = version.split('.').map { |num| num.to_i? }
    return nil if parts.any? { |part| part.nil? }
    major = parts.shift
    return nil if major.nil?
    minor = parts.shift?
    micro = parts.shift?
    nano = parts.shift?
    return self.new(major, minor, micro, nano)
  end

  # Compare two `Outdated::Version` values to each other. Conventional
  # version ordering is used.
  #
  # ```
  # v_1_2 = Outdated::Version.parse?("1.2")
  # v_1_2_0 = Outdated::Version.parse?("1.2.0")
  # v_1_2_1 = Outdated::Version.parse?("1.2.1")
  #
  # v_1_2_0 < v_1_2_1 # => true
  # v_1_2 < v_1_2_1   # => true
  # v_1_2 < v_1_2_0   # => true
  # ```
  def <=>(other)
    comps = self.to_a.zip(other.to_a).map { |a, b| cmp(a, b) }
    while comps.first? == 0
      comps.shift
    end
    comps.empty? ? 0 : comps.first
  end

  # Convert an `Outdated::Version` to a four element `Array(Int32?)`.
  def to_a
    [@major, @minor, @micro, @nano]
  end

  # Convert an `Outdated::Version` to a string. Normal version
  # dot-notation is used for the version number.
  #
  # ```
  # Outdated::Version.new(1, 2, 3).to_s # => "1.2.3"
  # ```
  def to_s(io)
    io << @major
    io << '.' << @minor unless @minor.nil?
    io << '.' << @micro unless @micro.nil?
    io << '.' << @nano unless @nano.nil?
  end

  private def cmp(a : Int32?, b : Int32?) : Int32
    unless a.nil?
      unless b.nil?
        a <=> b
      else
        1
      end
    else
      unless b.nil?
        -1
      else
        0
      end
    end
  end
end
