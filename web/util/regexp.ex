defmodule LolHero .Regexp do
  def username, do: ~r/^[a-z\d](?:[a-z\d]|-(?=[a-z\d])){1,64}$/
  def email, do: ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,32}$/
end
