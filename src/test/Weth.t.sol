// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/console.sol";
import {OperationTest, ERC20} from "./Operation.t.sol";
import {ShutdownTest} from "./Shutdown.t.sol";

import {IStrategyInterface} from "../interfaces/IStrategyInterface.sol";
import {CompoundV3LenderFactory, CompoundV3Lender} from "../CompoundV3LenderFactory.sol";

contract WethOperationTest is OperationTest {
    function setUp() public virtual override {
        super.setUp();

        asset = ERC20(0x4200000000000000000000000000000000000006);

        comet = 0x46e6b214b524310239732D51387075E0e70970bf;

        minFuzzAmount = minFuzzAmount * 1e10;
        maxFuzzAmount = maxFuzzAmount * 1e10;

        // Set decimals
        decimals = asset.decimals();

        // Deploy strategy and set variables
        strategy = IStrategyInterface(
            lenderFactory.newCompoundV3Lender(
                address(asset),
                "Tokenized Strategy",
                comet,
                0x806b4Ac04501c29769051e42783cF04dCE41440b
            )
        );

        vm.prank(management);
        strategy.acceptManagement();

        vm.prank(management);
        strategy.setUniFees(10000, 500);

        vm.prank(management);
        strategy.setPercentOut(0);
    }
}

contract WethShutdownTest is ShutdownTest {
    function setUp() public virtual override {
        super.setUp();

        asset = ERC20(0x4200000000000000000000000000000000000006);

        comet = 0x46e6b214b524310239732D51387075E0e70970bf;

        minFuzzAmount = minFuzzAmount * 1e10;
        maxFuzzAmount = maxFuzzAmount * 1e10;

        // Set decimals
        decimals = asset.decimals();

        // Deploy strategy and set variables
        strategy = IStrategyInterface(
            lenderFactory.newCompoundV3Lender(
                address(asset),
                "Tokenized Strategy",
                comet,
                0x9DDa783DE64A9d1A60c49ca761EbE528C35BA428
            )
        );

        vm.prank(management);
        strategy.acceptManagement();

        vm.prank(management);
        strategy.setUniFees(10000, 500);
    }
}
