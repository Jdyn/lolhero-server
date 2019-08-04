defmodule LolHero.Email do
    import Bamboo.Email

    def base_email() do
        new_email()
        |> from("")
    end
end