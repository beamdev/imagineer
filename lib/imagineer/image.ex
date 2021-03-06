defmodule Imagineer.Image do
  defstruct alias: nil, width: nil, height: nil, mask: nil, bit_depth: nil,
            color_format: nil, uri: nil, format: nil, attributes: %{}, content: <<>>,
            raw: nil, comment: nil
  alias Imagineer.Image
  alias Imagineer.Image.PNG

  @png_signature <<137::size(8), 80::size(8), 78::size(8), 71::size(8),
                13::size(8), 10::size(8), 26::size(8), 10::size(8)>>

  def load(%Image{uri: uri} = image) do
    case File.read(uri) do
      {:ok, file} ->
        %Image{image | raw: file}
      {:error, reason} -> {:error, "Could not open #{uri} due to #{reason}" }
    end
  end

  def process(%Image{raw: raw} = image) when not is_nil(raw) do
    case detect_format(image.raw) do
      :png ->
        image = %Image{image | format: :png}
        PNG.process(image)
    end
  end

  defp detect_format(<<@png_signature, _png_body::binary>>) do
    :png
  end
end
