// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IApeiAccount {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //
    // // // // // // // // // // // // // // // // // // // //
    // UTIL FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    // // // // // // // // // // // // // // // // // // // //
    // VIEW FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    function register(
        string memory _apeiSubdomain,
        bytes32 _apeiSubdomainNodeHash
    ) external;

    function startPayment() external;
}
