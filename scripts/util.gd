extends Node

func turn_phase_to_str(phase: Enum.TurnPhase) -> String:
    match phase:
        Enum.TurnPhase.Start:
            return "Start"
        Enum.TurnPhase.Player:
            return "Player"
        Enum.TurnPhase.Enemy:
            return "Enemy"
        Enum.TurnPhase.End:
            return "End"
        _:
            return "None"