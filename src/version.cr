# A `Outdated::Version` describes a version number with `#major`,
# `#minor`, `#micro`, and `#nano` components. Components beyond the
# `#major` number may be `nil`. Note that the largest value for any
# component is `2^16 - 1` (`65535`).
struct Outdated::Version
  getter major : UInt16
  getter minor : UInt16?
  getter micro : UInt16?
  getter nano : UInt16?

  include Comparable(Version)

  # Create a new `Outdated::Version` struct. The *major* number must not
  # be `nil`, but the other components may be.
  def initialize(@major : UInt16, @minor : UInt16? = nil,
                 @micro : UInt16? = nil, @nano : UInt16? = nil)
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
    parts = version.split('.').map { |num| num.to_u16? }
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

  # Convert an `Outdated::Version` to a four element `Array(UInt16?)`.
  def to_a : Array(UInt16?)
    [@major, @minor, @micro, @nano]
  end

  # Convert an `Outdated::Version` to a `UInt64`. This is done by
  # concatenating each component (`#major`, `#minor`, `#micro`, `#nano`)
  # into a `UInt64`. `nil` values are treated as zeros.
  def to_u64 : UInt64
    major = @major.to_u64
    minor = @minor.nil? ? 0_u64 : @minor.not_nil!.to_u64
    micro = @micro.nil? ? 0_u64 : @micro.not_nil!.to_u64
    nano = @nano.nil? ? 0_u64 : @nano.not_nil!.to_u64
    (major << 48) | (minor << 32) | (micro << 16) | nano
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

  private def cmp(a : UInt16?, b : UInt16?) : Int32
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
