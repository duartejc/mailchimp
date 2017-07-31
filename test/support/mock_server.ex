defmodule Mailchimp.MockServer do

  @dump_dir Path.join([
    File.cwd!,
    "priv",
    "test",
    "dump",
  ])

  @mock_dir Path.join([
    File.cwd!,
    "priv",
    "test",
    "mock",
  ])

  def dump(body) do
    id = body_id(body)
    IO.puts "# Mail Mock Response"

    if mock_exists(id) do
      IO.puts "Mock with ID #{id} Exists"
    else
      path = create_mock(id, body)
      IO.puts "New Mock with ID #{id} created in #{path}"
      IO.puts "Run the following command to save it:"
      IO.puts "$ MIX_ENV=test mix mailchimp.save_mock \"#{id}\""
    end

    body
  end

  def save(id) do
    if dump_exists(id) do
      File.rename(dump_path(id), mock_path(id))
    else
      IO.puts "Mock with ID #{id} does not exist"
    end
  end

  def delete(id) do
    if mock_exists(id) do
      File.rm!(mock_path(id))
    else
      IO.puts "Mock with ID #{id} does not exist"
    end
  end

  def flush_dumps do
    for file <- File.ls!(@dump_dir) do
      case file do
        "." <> _ ->
          :skip
        _ ->
          File.rm!(Path.join(@dump_dir, file))
      end
    end
  end

  def get(id) do
    id
    |> mock_path
    |> File.read!
    |> :erlang.binary_to_term
  end

  defp body_id(body) do
    :crypto.hash(:md5, :erlang.term_to_binary(body))
    |> Base.url_encode64(padding: false)
  end

  defp mock_path(id), do: Path.join(@mock_dir, "#{id}.erl")
  defp dump_path(id), do: Path.join(@dump_dir, "#{id}.erl")

  defp mock_exists(id), do: id |> mock_path |> File.exists?
  defp dump_exists(id), do: id |> dump_path |> File.exists?

  defp create_mock(id, body) do
    path = Path.join(@dump_dir, "#{id}.erl")

    File.write!(path, :erlang.term_to_binary(body))

    path
  end
end
