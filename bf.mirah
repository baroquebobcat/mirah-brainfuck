import java.io.InputStream
import java.io.StringBufferInputStream
import java.io.InputStreamReader
import java.io.Reader
import java.util.Arrays
import java.util.ArrayList
import java.util.List
import java.util.Stack

class BF
  def self.eval(str: String): void
    bf = BF.new StringBufferInputStream.new(str)
    bf.execute
  end
  def initialize source: InputStream
    @program = parse InputStreamReader.new source
    @jump_table = build_jump_table @program
    @instruction_index = 0
    @index = 0
    @array = char[30_000]
    Arrays.fill(@array, char(0))
  end

  def execute : void
    while @instruction_index < @program.size
      instruction = @program[@instruction_index]
      # puts "instr[#{@instruction_index}]: #{instruction} inx: #{@index} val-int: #{int(@array[@index])}"
      if instruction.equals :move_forward
        @index += 1
      elsif instruction.equals :move_back
        @index -= 1
      elsif instruction.equals :increment
        @array[@index] = char(int(@array[@index]) + 1)
      elsif instruction.equals :decrement
        @array[@index] = char(int(@array[@index]) - 1)
      elsif instruction.equals :print
        print @array[@index]
      elsif instruction.equals :get
        @array[@index] = char(System.in.read)
      elsif instruction.equals :begin
        if int(@array[@index]) == 0
          @instruction_index = @jump_table[@instruction_index]
        end
      elsif instruction.equals :stop
        if int(@array[@index]) != 0
          @instruction_index = @jump_table[@instruction_index]
        end
      else
        puts "argh #{instruction}"
      end
      @instruction_index+=1
    end
  end
  def parse(reader: Reader):List
    instructions = []
    while (c = reader.read) > 0
      cmd = char(c)
      if cmd == ?>
        instructions.add :move_forward
      elsif cmd == ?<
        instructions.add :move_back
      elsif cmd == ?+
        instructions.add :increment
      elsif cmd == ?-
        instructions.add :decrement
      elsif cmd == ?.
        instructions.add :print
      elsif cmd == ?,
        instructions.add :get
      elsif cmd == ?[
        instructions.add :begin
      elsif cmd == ?]
        instructions.add :stop
      else
        # ignored char
      end
    end
    instructions
  end

  def build_jump_table(instructions: List): int[]
    loop_stack = Stack.new
    jump_table = int[instructions.size]
    # instructions.each_with_index do |instruction, index| # aspirational
    index = 0
    while index < instructions.size
      instruction = instructions.get index

      if instruction.equals :begin
        loop_stack.push Integer.toString(index) # generic + primitive boxing fail
      elsif instruction.equals :stop
        last_begin_index = Integer.parseInt(loop_stack.pop) # cast? generic inf error
        jump_table[last_begin_index] = index
        jump_table[index] = last_begin_index
      end
      index+=1
    end
    jump_table
  end
end