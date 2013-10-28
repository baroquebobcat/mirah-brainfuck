import java.io.InputStream
import java.io.StringBufferInputStream
import java.io.InputStreamReader
import java.io.Reader
import java.util.Arrays
import java.util.ArrayList
import java.util.List

class BF
  def self.eval(str: String): void
    bf = BF.new StringBufferInputStream.new(str)
    bf.execute
  end
  def initialize source: InputStream
    @program = parse InputStreamReader.new source
    @instruction_index = 0
    @index = 0
    @array = char[30_000]
    Arrays.fill(@array, char(0))
  end

  def execute : void
    while @instruction_index < @program.size
      instruction = @program[@instruction_index]
      #puts "instr[#{@instruction_index}]: #{instruction} inx: #{@index} val-int: #{int(@array[@index])}"
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
        # TODO
        puts "AAaaaagh!"
      elsif instruction.equals :begin
        if int(@array[@index]) == 0
          while @program[@instruction_index] != :stop
            @instruction_index+=1
          end
        end
      elsif instruction.equals :stop
        if int(@array[@index]) != 0
          while @program[@instruction_index] != :begin
            @instruction_index -= 1
          end
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
        puts cmd
      end
    end
    instructions
  end
end