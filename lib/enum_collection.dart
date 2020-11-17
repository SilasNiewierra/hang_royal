enum GameState { idle, running, succeeded, failed }

enum BodyParts { head, body, arm_left, arm_right, leg_left, leg_right }

enum PlayableCharacters { orc, witch, pirate, wolf }

enum Powers { freeze, reset, reveal }

enum FreezeState {
  none,
  cracks_none,
  cracks_one,
  cracks_two,
  cracks_three,
  explode
}
