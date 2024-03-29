// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import {CompoundV3Lender} from "./CompoundV3Lender.sol";
import {IStrategyInterface} from "./interfaces/IStrategyInterface.sol";

contract CompoundV3LenderFactory {
    /// @notice Revert message for when a strategy has already been deployed.
    error AlreadyDeployed(address _strategy);

    event NewCompoundV3Lender(address indexed strategy, address indexed asset);

    address public management;
    address public performanceFeeRecipient;
    address public keeper;

    /// @notice Track the deployments. comet => strategy
    mapping(address => address) public deployments;

    constructor(
        address _management,
        address _performanceFeeRecipient,
        address _keeper
    ) {
        require(_management != address(0), "ZERO ADDRESS");
        management = _management;
        performanceFeeRecipient = _performanceFeeRecipient;
        keeper = _keeper;
    }

    /**
     * @notice Deploy a new Compound V3 Lender.
     * @dev This will set the msg.sender to all of the permissioned roles.
     * @param _asset The underlying asset for the lender to use.
     * @param _name The name for the lender to use.
     * @return . The address of the new lender.
     */
    function newCompoundV3Lender(
        address _asset,
        string memory _name,
        address _comet,
        address _rewardToAssetOracle
    ) external returns (address) {
        if (deployments[_comet] != address(0))
            revert AlreadyDeployed(deployments[_comet]);
        // We need to use the custom interface with the
        // tokenized strategies available setters.
        IStrategyInterface newStrategy = IStrategyInterface(
            address(
                new CompoundV3Lender(
                    _asset,
                    _name,
                    _comet,
                    _rewardToAssetOracle
                )
            )
        );

        newStrategy.setPerformanceFeeRecipient(performanceFeeRecipient);

        newStrategy.setKeeper(keeper);

        newStrategy.setPendingManagement(management);

        emit NewCompoundV3Lender(address(newStrategy), _asset);

        deployments[_comet] = address(newStrategy);
        return address(newStrategy);
    }

    function setAddresses(
        address _management,
        address _performanceFeeRecipient,
        address _keeper
    ) external {
        require(msg.sender == management, "!management");
        management = _management;
        performanceFeeRecipient = _performanceFeeRecipient;
        keeper = _keeper;
    }

    function isDeployedStrategy(
        address _strategy
    ) external view returns (bool) {
        address _comet = IStrategyInterface(_strategy).comet();
        return deployments[_comet] == _strategy;
    }
}
