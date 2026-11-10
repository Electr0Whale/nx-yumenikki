#include <iostream>
#include <cassert>
#include <bitset>
#include "platform/switch/input_mapping.h"

int main() {
    std::cout << "Testing SwitchInput::ApplyPad with new layout..." << std::endl;
    std::bitset<Input::Keys::KEYS_COUNT> keys;
    SwitchInput::ModifierState state;
    SwitchInput::PadState pad;

    // Test 1: A -> JOY_A (互动 / 决定)
    pad.a = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_A] == true);
    assert(keys[Input::Keys::N1] == false);
    pad.a = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_A] == false);

    // Test 2: B -> JOY_B (Menu / Cancel)
    pad.b = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_B] == true);
    assert(keys[Input::Keys::N3] == false);
    pad.b = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_B] == false);

    // Test 3: X -> N1 (使用效果 / 坐下，数字键1)
    pad.x = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N1] == true);
    assert(keys[Input::Keys::JOY_X] == false);
    pad.x = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N1] == false);

    // Test 4: Y -> N3 (退出效果，数字键3)
    pad.y = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N3] == true);
    assert(keys[Input::Keys::JOY_Y] == false);
    pad.y = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N3] == false);

    // Test 5: L -> N5 (丢下效果，数字键5)
    pad.l = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N5] == true);
    assert(keys[Input::Keys::JOY_SHOULDER_LEFT] == false);
    pad.l = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N5] == false);

    // Test 6: R -> N9 (醒来，数字键9)
    pad.r = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N9] == true);
    assert(keys[Input::Keys::JOY_SHOULDER_RIGHT] == false);
    pad.r = false;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::N9] == false);

    // Test 7: Plus (+) -> JOY_START (加速), Minus (-) -> JOY_BACK (EasyRPG设置菜单)
    pad.plus = true;
    pad.minus = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_START] == true);
    assert(keys[Input::Keys::JOY_BACK] == true);
    pad.plus = false;
    pad.minus = false;

    // Test 8: ZR -> JOY_RTRIGGER_FULL (加速)
    pad.zr = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_RTRIGGER_FULL] == true);
    pad.zr = false;

    // Test 9: ZL -> JOY_LTRIGGER_FULL is false (exclusive for bezel toggle)
    pad.zl = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_LTRIGGER_FULL] == false);
    pad.zl = false;

    // Test 10: D-Pad navigation
    pad.up = true;
    pad.down = true;
    pad.left = true;
    pad.right = true;
    SwitchInput::ApplyPad(pad, keys, state);
    assert(keys[Input::Keys::JOY_DPAD_UP] == true);
    assert(keys[Input::Keys::JOY_DPAD_DOWN] == true);
    assert(keys[Input::Keys::JOY_DPAD_LEFT] == true);
    assert(keys[Input::Keys::JOY_DPAD_RIGHT] == true);

    std::cout << "All SwitchInput::ApplyPad unit tests PASSED successfully!" << std::endl;
    return 0;
}
