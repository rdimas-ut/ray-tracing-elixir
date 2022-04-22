defmodule Vec3 do
    alias Vec3, as: Color
    alias Vec3, as: Point3

    @type vec3 :: {float, float, float}

    @spec x(vec3) :: vec3
    def x(a) do
        elem(a, 0)
    end

    @spec y(vec3) :: vec3
    def y(a) do
        elem(a, 1)
    end

    @spec z(vec3) :: vec3
    def z(a) do
        elem(a, 2)
    end

    @spec neg(vec3) :: vec3
    def neg(a) do
        {-elem(a, 0), -elem(a, 1), -elem(a, 2)}
    end

    @spec add(vec3, vec3) :: vec3
    def add(a, b) do
        {elem(a, 0) + elem(b, 0), elem(a, 1) + elem(b, 1), elem(a, 2) + elem(b, 2)}
    end

    @spec sub(vec3, vec3) :: vec3
    def sub(a, b) do
        {elem(a, 0) - elem(b, 0), elem(a, 1) - elem(b, 1), elem(a, 2) - elem(b, 2)}
    end

    @spec mult(vec3 | float, float | vec3) :: vec3
    def mult(a, b) when is_float(b) do
        {elem(a, 0) * b, elem(a, 1) * b, elem(a, 2) * b}
    end

    def mult(a, b) when is_float(a) do
        Vec3.mult(b, a)
    end

    def mult(a, b) do
        {elem(a, 0) * elem(b, 0), elem(a, 1) * elem(b, 1), elem(a, 2) * elem(b, 2)}
    end

    @spec div(vec3, float) :: vec3
    def div(a, b) do
        {elem(a, 0) / b, elem(a, 1) / b, elem(a, 2) / b}
    end

    @spec length(vec3) :: vec3
    def length(a) do
        a |> Vec3.length_squared() |> :math.sqrt()
    end

    @spec length_squared(vec3) :: vec3
    def length_squared(a) do
        (elem(a, 0) * elem(a, 0)) + (elem(a, 1) * elem(a, 1)) + (elem(a, 2) * elem(a, 2))
    end

    @spec dot(vec3, vec3) :: float
    def dot(a, b) do
        elem(a, 0) * elem(b, 0) + elem(a, 1) * elem(b, 1) + elem(a, 2) * elem(b, 2)
    end

    @spec cross(vec3, vec3) :: vec3
    def cross(a, b) do
        {elem(a, 1) * elem(b, 2) - elem(a, 2) * elem(b, 1), elem(a, 2) * elem(b, 0) - elem(a, 0) * elem(b, 2), elem(a, 0) * elem(b, 1) - elem(a, 1) * elem(b, 0)}
    end

    @spec unit_vector(vec3) :: float
    def unit_vector(a) do
      Vec3.div(a, Vec3.length(a))
    end

end

defmodule Color do
    @spec write_color(Vec3.vec3) :: none
    def write_color(pixel_color) do
        IO.puts "#{trunc(Vec3.x(pixel_color) * 255.999)}" <> " " <> "#{trunc(Vec3.y(pixel_color) * 255.999)}" <> " " <> "#{trunc(Vec3.z(pixel_color) * 255.999)}"
    end
end

defmodule Main do
    def main() do

        # Image

        image_width = 256
        image_height = 256

        # Render

        IO.puts "P3\n" <> "#{image_width}" <> " " <> "#{image_height}" <> "\n255"

        for j <- Enum.reverse(0..image_height-1) do
            IO.puts(:stderr, "\rScanlines remaining: #{j}")
            for i <- 0..image_width-1 do
                pixel_color = {i / (image_width - 1), j / (image_height - 1), 0.25};
                Color.write_color(pixel_color);
            end
        end

        IO.puts(:stderr, "Done.")
    end
end

Main.main()
