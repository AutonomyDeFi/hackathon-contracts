// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IApeiFactory {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // UTIL FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Pause this contract
     * @param val Pause state to set
     */
    function pause(bool val) external;

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice This creates a new apei and returns the address of the newly deployed contract
     * @param apeiCost the cost of the apei
     * @param apeiApi the url of the apei
     * @param apeiName the name of the apei
     * @param apeiDescription the description of the apei
     * @param apeiSubdomain the ENS subdomain of the apei
     * @param apeiTag the tag of the apei
     * @param apeiSubdomainNodeHash the ENS node hash subdomain of the apei
     * @param _salt The salt to create the contract with
     * @return createdApei address of the newly deployed contract
     */
    function createApei(
        uint256 apeiCost,
        string memory apeiApi,
        string memory apeiName,
        string memory apeiDescription,
        string memory apeiSubdomain,
        string memory apeiTag,
        bytes32 apeiSubdomainNodeHash,
        bytes32 _salt
    ) external returns (address);

    // // // // // // // // // // // // // // // // // // // //
    // VIEW FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends back the list of apeis
     * @return apeiIds list of ids
     */
    function getAllApeis() external view returns (uint256[] memory);

    /**
     * @notice Sends back api of the ApeI
     * @return apeiApi the api of the ApeI
     */
    function getApeiApi(uint256 apeiId) external view returns (string memory);

    /**
     * @notice Sends back cost of the ApeI
     * @return apeiCost the cost of the ApeI
     */
    function getApeiCost(uint256 apeiId) external view returns (uint256);

    /**
     * @notice Sends back description of the ApeI
     * @return apeiDescription the description of the ApeI
     */
    function getApeiDescription(
        uint256 apeiId
    ) external view returns (string memory);

    /**
     * @notice Sends back name of the ApeI
     * @return apeiName the name of the ApeI
     */
    function getApeiName(uint256 apeiId) external view returns (string memory);

    /**
     * @notice Sends back subdomain of the ApeI
     * @return apeiSubdomain the subdomain of the ApeI
     */
    function getApeiSubdomain(
        uint256 apeiId
    ) external view returns (string memory);

    /**
     * @notice Sends back tag of the ApeI
     * @return apeiTag the tag of the ApeI
     */
    function getApeiTag(uint256 apeiId) external view returns (string memory);

    /**
     * @notice Sends back account address of the ApeI
     * @return apeiAccountAddress the account address of the ApeI
     */
    function getApeiAccountAddress(
        uint256 apeiId
    ) external view returns (address);
}
