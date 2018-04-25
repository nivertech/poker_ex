defmodule PokerEx.GameEngine.PhaseManager do
  alias PokerEx.GameEngine.ChipManager

  @spec maybe_change_phase(PokerEx.GameEngine.Impl.t()) :: PokerEx.GameEngine.Impl.t()
  def maybe_change_phase(%{phase: :idle} = engine) do
    case length(engine.seating.arrangement) >= 2 do
      true ->
        %PokerEx.GameEngine.Impl{
          engine
          | phase: :pre_flop,
            chips: ChipManager.post_blinds(engine)
        }

      false ->
        engine
    end
  end

  def maybe_change_phase(engine), do: engine
end