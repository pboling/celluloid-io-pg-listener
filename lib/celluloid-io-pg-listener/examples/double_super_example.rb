module InitializerEnhancer

  def initialize(callback_method:)
    # Class including this one must define the callback method
    define_singleton_method(callback_method) {
      super("banana") # <- Works just like you hoped it would.
    }
    super()
  end

end

class SillyMonkey

  prepend InitializerEnhancer

  def initialize
    puts "LOL Nothing happened."
  end

  def eat_thing(thing)
    raise RuntimeError, "I ate a #{thing}"
  end

end

class HappyMonkey < SillyMonkey

  def eat_thing(thing)
    puts "Dreaming about #{thing}"
  end

end

# >> a = HappyMonkey.new(callback_method: "eat_thing")
# LOL Nothing happened.
#             => #<HappyMonkey:0x007f901b877528>
#
# >> a.eat_thing
# Dreaming about banana
# => nil
#
# >> b = SillyMonkey.new(callback_method: "eat_thing")
# LOL Nothing happened.
# => #<SillyMonkey:0x007f90199199b0>
#
# >> b.eat_thing
# RuntimeError: I ate a banana
# from (irb):22:in `eat_thing'
# 	from (irb):6:in `block in initialize'
