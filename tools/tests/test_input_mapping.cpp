#include <iostream>
#include <cassert>
#include <bitset>
#include "platform/switch/input_mapping.h"

int main() {
    std::cout << "Testing SwitchInput::ApplyPad..." << std::endl;
    std::bitset<Input::Keys::KEYS_COUNT> keys;
    SwitchInput::ModifierState state;
    SwitchInput::PadState pad;

    // Test 1: Normal buttons
    pad.a = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_A] == true);
    assert(keys[Input::Keys::N1] == false);
    pad.a = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_A] == false);

    // Test 2: Pinch cheek (X -> N9)
    pad.x = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N9] == true);
    assert(keys[Input::Keys::JOY_X] == false);
    pad.x = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N9] == false);

    // Test 3: Drop effect (Y -> N5)
    pad.y = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N5] == true);
    assert(keys[Input::Keys::JOY_Y] == false);
    pad.y = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N5] == false);

    // Test 4: Run (R -> JOY_SHOULDER_RIGHT)
    pad.r = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_SHOULDER_RIGHT] == true);
    pad.r = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_SHOULDER_RIGHT] == false);

    // Test 5: Plus menu & Minus settings
    pad.plus = true;
    pad.minus = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_START] == true);
    assert(keys[Input::Keys::JOY_BACK] == true);
    pad.plus = false;
    pad.minus = false;

    // Test 6: Fast Forward (ZR)
    pad.zr = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_RTRIGGER_FULL] == true);
    pad.zr = false;

    // Test 7: L + A -> N1 (Effect Action 1) with release latch
    // 1) Hold L
    pad.l = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N1] == false);
    assert(keys[Input::Keys::JOY_A] == false);

    // 2) Press A while holding L -> N1 active, JOY_A suppressed
    pad.a = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N1] == true);
    assert(keys[Input::Keys::JOY_A] == false);

    // 3) Release L before A -> N1 stops, JOY_A STILL suppressed (latch active!)
    pad.l = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N1] == false);
    assert(keys[Input::Keys::JOY_A] == false); // Suppressed to prevent accidental confirm!

    // 4) Release A -> latch resets
    pad.a = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_A] == false);
    assert(state.suppress_normal_a == false);

    // Test 8: L + B -> N3 (Effect Action 2) with reverse chord suppression
    // 1) Hold B first (e.g. canceling menu)
    pad.b = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_B] == true);
    assert(keys[Input::Keys::N3] == false);

    // 2) Accidentally press L while B held -> N3 suppressed!
    pad.l = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N3] == false);
    assert(keys[Input::Keys::JOY_B] == false); // B is suppressed while L is down

    // 3) Release B
    pad.b = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(state.suppress_chord_b == false);

    std::cout << "All SwitchInput::ApplyPad unit tests PASSED successfully!" << std::endl;
    return 0;
}
