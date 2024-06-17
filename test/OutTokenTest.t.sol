// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployOurToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployOurToken = new DeployOurToken();
        ourToken = deployOurToken.run();

        vm.prank(address(deployOurToken));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}
