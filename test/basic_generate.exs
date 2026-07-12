le# Run with:
#   iex -S mix run reqllm_demo/test/basic_generate.exs

require IEx

# Ensure dotenv loads .env file if present.
# By default Dotenvy only stores vars in process state; use `side_effect` to
# push them into System.env/1 so ReqLLM's key lookups work.
{:ok, _} = Dotenvy.source(".env", side_effect: &System.put_env/1)

model = System.get_env("REQ_LLM_MODEL", "openai:gpt-4o-mini")

IO.puts(">> 1. Asking the model a simple question (Model: #{model})...")
IO.puts("  (Pausing for inspection. Type `continue` or `respawn` to proceed.)")

# A simple synchronous call.
# No tools, no streaming, just a prompt string.
{:ok, response} = ReqLLM.generate_text(model, "Explain why Elixir is great in one sentence.")

IO.puts(">> 2. Response received.")
IEx.pry()

# Extract the text from the response
text = ReqLLM.Response.text(response)

IO.puts("\n>> Answer:\n")
IO.puts(text)
