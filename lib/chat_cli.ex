defmodule ChatCLI do
  def start do
    IO.puts("Welcome to Elixir LLM Chat! (Type 'exit' to quit)")
    loop()
  end

  def loop do
    # Create a custom prompt
    input = IO.gets("\nchat> ") |> String.trim()

    case input do
      text when text in ["exit", "quit", "q"] ->
        IO.puts("Goodbye!")
        :ok
      "" ->
        loop() # Ignore empty inputs
      prompt ->
        IO.puts("\n🤖 Thinking...\n")
        response = query_llm(prompt)
        IO.puts("🤖 LLM: #{response}")
        loop() # Recursively call loop to keep the chat going
    end
  end

  defp query_llm(prompt) do
    model_spec = ReqLLM.model!(%{provider: :ollama, id: "llama3.2"})
    case ReqLLM.generate_text(model_spec, prompt) do
      {:ok, response} ->
        ReqLLM.Response.text(response)
      {:error, reason} ->
        {:error ,reason}
    end
  end
end
