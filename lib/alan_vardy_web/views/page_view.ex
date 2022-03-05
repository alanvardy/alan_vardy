defmodule AlanVardyWeb.PageView do
  @moduledoc false
  use AlanVardyWeb, :view

  @cards [
    %{
      title: "I'm a Canadian and a New Zealander",
      content: """
      I was born and raised in the land of sheep, kiwis, and hobbits. \
      I have lived in a few different countries, travelled across most \
      of the world's continents, and value those experiences.\
      """,
      path: "images/newzealand.jpg"
    },
    %{
      title: "I'm a father and a husband",
      content: """
      I am intentional about how I spend my time and energy, and focus \
      on my work so I can then focus on my family.
      """,
      path: "images/family.jpg"
    },
    %{
      title: "I spent 5 years in the Canadian Forces",
      content:
        "Lets just say that the Combat Engineers have fantastic recruiting videos, and that Afghanistan had a lot of sand but no beaches.",
      path: "images/combatengineer.jpg"
    },
    %{
      title: "I am a Journeyman Refrigeration Mechanic",
      content:
        "An excellent trade. I have now traded in my tools and steel-toed boots for a keyboard and comfortable slippers. The work ethic remains the same.",
      path: "images/refrigeration.jpg"
    }
  ]

  @type card :: %{content: String.t(), path: String.t(), title: String.t()}

  @doc "List of items to be diplayed on aboutme page"
  @spec cards :: [card, ...]
  def cards, do: @cards
end
