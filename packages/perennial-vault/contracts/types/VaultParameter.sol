// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import "@equilibria/perennial-v2/contracts/interfaces/IFactory.sol";
import "@equilibria/root-v2/contracts/UFixed6.sol";
import "./Checkpoint.sol";

/// @dev VaultParameter type
struct VaultParameter {
    IFactory factory;
    Token18 asset;
    UFixed6 leverage;
    UFixed6 cap;
    UFixed6 premium;
}
struct StoredVaultParameter {
    // slot 1
    address _factory;
    uint32 _leverage;
    uint64 _cap;

    // slot 2
    address _asset;
    uint24 _premium;
    bytes9 __unallocated__;
}
struct VaultParameterStorage { StoredVaultParameter value; }
using VaultParameterStorageLib for VaultParameterStorage global;

library VaultParameterStorageLib {
    error VaultParameterStorageInvalidError();

    function read(VaultParameterStorage storage self) internal view returns (VaultParameter memory) {
        StoredVaultParameter memory storedValue = self.value;
        return VaultParameter(
            IFactory(storedValue._factory),
            Token18.wrap(storedValue._asset),
            UFixed6.wrap(uint256(storedValue._leverage)),
            UFixed6.wrap(uint256(storedValue._cap)),
            UFixed6.wrap(uint256(storedValue._premium))
        );
    }

    function store(VaultParameterStorage storage self, VaultParameter memory newValue) internal {
        if (newValue.leverage.gt(UFixed6Lib.MAX_32)) revert VaultParameterStorageInvalidError();
        if (newValue.cap.gt(UFixed6Lib.MAX_64)) revert VaultParameterStorageInvalidError();
        if (newValue.premium.gt(UFixed6Lib.MAX_24)) revert VaultParameterStorageInvalidError();

        self.value = StoredVaultParameter(
            address(newValue.factory),
            uint32(UFixed6.unwrap(newValue.leverage)),
            uint64(UFixed6.unwrap(newValue.cap)),
            Token18.unwrap(newValue.asset),
            uint24(UFixed6.unwrap(newValue.premium)),
            bytes9(0)
        );
    }
}
