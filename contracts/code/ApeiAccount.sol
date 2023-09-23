// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Context.sol";

// Local imports
import "../interfaces/IApeiAccount.sol";
import "../utils/IReverseRegistrar.sol";

contract ApeiAccount is IApeiAccount, Context {
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    struct PaymentReceiptDetailsMapObject {
        uint256 paymentReceiptId;
        address payerAddress;
        bool isUsed;
        bool isValid;
    }

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES
    // // // // // // // // // // // // // // // // // // // //

    // ENS ReserveRegistrar Contract
    address public constant REVERSE_REGISTRAR_ADDRESS =
        0x4f7A657451358a22dc397d5eE7981FfC526cd856;

    // Address of the person that created the apei
    address public apeiFactory;
    address public apeiCreator;
    uint256 public apeiId;
    string public apeiSubdomain;
    bytes32 public apeiSubdomainNodeHash;

    // id of payment receipt -> struct of payment receipt info
    mapping(uint256 => PaymentReceiptDetailsMapObject)
        internal _paymentReceiptDetails;

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //

    constructor(uint256 _apeiId, address _apeiCreator, address _apeiFactory) {
        apeiCreator = _apeiCreator;
        apeiId = _apeiId;
        apeiFactory = _apeiFactory;
    }

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    modifier onlyApeiCreator(address _apeiCreator) {
        require(_apeiCreator == _msgSender(), "Must be the apei creator");

        _;
    }

    modifier onlyFactory() {
        require(apeiFactory == _msgSender(), "Must be the apei factory");

        _;
    }

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONALITY
    // // // // // // // // // // // // // // // // // // // //

    function register(
        string memory _apeiSubdomain,
        bytes32 _apeiSubdomainNodeHash
    ) external override onlyFactory {
        apeiSubdomain = _apeiSubdomain;
        apeiSubdomainNodeHash = _apeiSubdomainNodeHash;

        // Sets the current address as the primary ENS name with forward and backward resolution
        IReverseRegistrar(REVERSE_REGISTRAR_ADDRESS).setName(_apeiSubdomain);
    }
}
