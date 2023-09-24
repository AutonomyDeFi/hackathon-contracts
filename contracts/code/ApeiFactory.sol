// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

// Local imports
import "../interfaces/IApeiFactory.sol";
import "../utils/IAddrResolver.sol";
import "../utils/INameWrapper.sol";
import "../utils/IReverseRegistrar.sol";
import "./ApeiAccount.sol";

contract ApeiFactory is Context, Ownable, Pausable, IApeiFactory {
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    struct ApeiDetailsMapObject {
        uint256 apeiId;
        uint256 apeiCost;
        address accountAddress;
        address creatorAccress;
        bool isValid;
        string apeiApi;
        string apeiName;
        string apeiDescription;
        string apeiSubdomain;
        string apeiTag;
        bytes32 apeiSubdomainNodeHash;
    }

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES
    // // // // // // // // // // // // // // // // // // // //
    // Ape Token Contract
    address public constant APE_TOKEN =
        0x328507DC29C95c170B56a1b3A758eB7a9E73455c;

    // ENS NameWrapper Contract
    bytes32 public constant APEI_ENS_NODE_HASH =
        0x5bf464e0f45eab3cb7a31d7a4e241d8036864e667ebdaf433d49fb9275efaf2e;

    // ENS NameWrapper Contract
    address public constant NAME_WRAPPER_ADDRESS =
        0x114D4603199df73e7D157787f8778E21fCd13066;

    // ENS PublicResolver Contract
    address public constant PUBLIC_RESOLVER_ADDRESS =
        0xd7a4F6473f32aC2Af804B3686AE8F1932bC35750;

    // List of all the payments receipts
    address private _apeiDomainOwner;

    // List of all the apeis
    uint256[] private _apeiIds;

    // id of apei -> struct of ApeI  info
    mapping(uint256 => ApeiDetailsMapObject) internal _apeiDetails;

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //

    constructor(address apeiDomainOwner_) {
        _apeiDomainOwner = apeiDomainOwner_;
    }

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // UTIL FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Pause this contract
     * @param val Pause state to set
     */
    function pause(bool val) external override onlyOwner {
        if (val == true) {
            _pause();
            return;
        }
        _unpause();
    }

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONALITY
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
    ) external override returns (address) {
        // Make up some simple random id
        uint256 apeiId = uint256(keccak256(abi.encodePacked(_apeiIds.length)));

        // Create the apei account
        ApeiAccount apeiAccount = new ApeiAccount{salt: _salt}(
            apeiId,
            _msgSender(),
            address(this),
            apeiTag
        );

        // Set up the struct
        ApeiDetailsMapObject storage apeiDetailsMapObj = _apeiDetails[apeiId];

        // Set up the struct of the streamer agent details
        apeiDetailsMapObj.apeiId = apeiId;
        apeiDetailsMapObj.apeiCost = apeiCost;
        apeiDetailsMapObj.accountAddress = address(apeiAccount);
        apeiDetailsMapObj.creatorAccress = _msgSender();
        apeiDetailsMapObj.isValid = true;
        apeiDetailsMapObj.apeiApi = apeiApi;
        apeiDetailsMapObj.apeiName = apeiName;
        apeiDetailsMapObj.apeiDescription = apeiDescription;
        apeiDetailsMapObj.apeiSubdomain = apeiSubdomain;
        apeiDetailsMapObj.apeiTag = apeiTag;
        apeiDetailsMapObj.apeiSubdomainNodeHash = apeiSubdomainNodeHash;

        // Creates the Subdomain on the NameWrapper Contract
        INameWrapper(NAME_WRAPPER_ADDRESS).setSubnodeRecord(
            // bytes32 parentNode,
            APEI_ENS_NODE_HASH,
            // string label,
            apeiSubdomain,
            // address owner,
            _apeiDomainOwner,
            // address resolver,
            PUBLIC_RESOLVER_ADDRESS,
            // uint64 ttl,
            0,
            // uint32 fuses,
            0,
            // uint64 expiry
            0
        );

        // Adds the new address to the PublicResolver Contract
        IAddrResolver(PUBLIC_RESOLVER_ADDRESS).setAddr(
            apeiDetailsMapObj.apeiSubdomainNodeHash,
            address(this)
        );

        // Tells the child apei account to save the domain details
        apeiAccount.register(
            // string memory _apeiSubdomain,
            apeiSubdomain,
            // bytes32 _apeiSubdomainNodeHash
            apeiSubdomainNodeHash
        );

        return address(apeiAccount);
    }

    // // // // // // // // // // // // // // // // // // // //
    // VIEW FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends back the list of apeis
     * @return apeiIds list of ids
     */
    function getAllApeis() external view override returns (uint256[] memory) {
        return _apeiIds;
    }

    /**
     * @notice Sends back api of the ApeI
     * @return apeiApi the api of the ApeI
     */
    function getApeiApi(
        uint256 apeiId
    ) external view override returns (string memory) {
        return _apeiDetails[apeiId].apeiApi;
    }

    /**
     * @notice Sends back cost of the ApeI
     * @return apeiCost the cost of the ApeI
     */
    function getApeiCost(
        uint256 apeiId
    ) external view override returns (uint256) {
        return _apeiDetails[apeiId].apeiCost;
    }

    /**
     * @notice Sends back description of the ApeI
     * @return apeiDescription the description of the ApeI
     */
    function getApeiDescription(
        uint256 apeiId
    ) external view override returns (string memory) {
        return _apeiDetails[apeiId].apeiDescription;
    }

    /**
     * @notice Sends back name of the ApeI
     * @return apeiName the name of the ApeI
     */
    function getApeiName(
        uint256 apeiId
    ) external view override returns (string memory) {
        return _apeiDetails[apeiId].apeiName;
    }

    /**
     * @notice Sends back subdomain of the ApeI
     * @return apeiSubdomain the subdomain of the ApeI
     */
    function getApeiSubdomain(
        uint256 apeiId
    ) external view override returns (string memory) {
        return _apeiDetails[apeiId].apeiSubdomain;
    }

    /**
     * @notice Sends back tag of the ApeI
     * @return apeiTag the tag of the ApeI
     */
    function getApeiTag(
        uint256 apeiId
    ) external view override returns (string memory) {
        return _apeiDetails[apeiId].apeiTag;
    }

    /**
     * @notice Sends back account address of the ApeI
     * @return apeiAccountAddress the account address of the ApeI
     */
    function getApeiAccountAddress(
        uint256 apeiId
    ) external view override returns (address) {
        return _apeiDetails[apeiId].accountAddress;
    }
}
