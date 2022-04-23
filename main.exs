defmodule Vec3 do
    @type vec3 :: {float, float, float}
    @type point3 :: vec3
    @type color :: vec3

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

defmodule Ray do
    defstruct orig: {0.0, 0.0, 0.0}, direction: {0.0, 0.0, 0.0}

    @type t :: %__MODULE__{
        orig: Vec3.point3,
        direction: Vec3.vec3
    }
end

defmodule Main do
    @spec ray_color(Ray.t()) :: Vec3.color
    def ray_color(r) do
        unit_direction = Vec3.unit_vector(r.direction)
        t = 0.5 * (Vec3.y(unit_direction) + 1.0)
        Vec3.mult(1.0 - t, {1.0, 1.0, 1.0}) |> Vec3.add(Vec3.mult(t, {0.5, 0.7, 1.0}))
    end

    def main() do

        # Image
        aspect_ratio = 16.0 / 9.0
        image_width = 400
        image_height = trunc(image_width / aspect_ratio)

        # Camera
        viewport_height = 2.0;
        viewport_width = aspect_ratio * viewport_height;
        focal_length = 1.0;

        origin = {0.0, 0.0, 0.0};
        horizontal = {viewport_width, 0.0, 0.0};
        vertical = {0.0, viewport_height, 0.0};

        # lower_left_corner = origin - horizontal/2 - vertical/2 - vec3(0, 0, focal_length);
        lower_left_corner = origin |> Vec3.sub(Vec3.div(horizontal, 2.0)) |> Vec3.sub(Vec3.div(vertical, 2.0)) |> Vec3.sub({0.0, 0.0, focal_length})

        # Render

        IO.puts "P3\n" <> "#{image_width}" <> " " <> "#{image_height}" <> "\n255"

        for j <- Enum.reverse(0..image_height-1) do
            IO.puts(:stderr, "\rScanlines remaining: #{j}")
            for i <- 0..image_width-1 do
                u = i / (image_width - 1)
                v = j / (image_height - 1)
                r = %Ray{orig: origin, direction: lower_left_corner |> Vec3.add(Vec3.mult(u, horizontal)) |> Vec3.add(Vec3.mult(v, vertical)) |> Vec3.sub(origin)}
                ray_color(r) |> Color.write_color()
                #pixel_color = {i / (image_width - 1), j / (image_height - 1), 0.25};
                # Color.write_color(pixel_color);
            end
        end

        IO.puts(:stderr, "Done.")
    end
end

Main.main()
