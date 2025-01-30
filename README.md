# Solidity Gas Optimization Examples #

A collection of solidity gas optimization examples to see what works and what doesn't with optimizer enabled and disabled.

## Setup ##

Ensure you are using a recent version of [Foundry](https://github.com/foundry-rs/foundry) that supports Solidity >= 0.8.28.

Compile with: `forge build`

Every test file has instructions on how to run the individual tests.

## Results ##

### #1 Don't Initialize To Default Value: NOT EFFECTIVE ###

Solidity by default initializes variables to default values, so one common recommendation is to not initialize loop variables to their default value:
```solidity
// both implementations cost the same gas
for(uint256 i=0; i<numIds; i++) {
for(uint256 i;   i<numIds; i++) {
```

Testing shows this suggestion is not cheaper regardless of whether the optimizer is enabled. The code without initialization may still be preferred for its succinctness.

### #2 Initialize Past Default Value: EFFECTIVE 12% CHEAPER ###

If a variable (especially a storage variable) can be initialized past its default value, this offers significantly cheaper gas cost in the function call that would subsequently change it:
```diff
contract IdRegUnop is IIdReg {
    // next available id
-   uint256 public nextId;
+   uint256 public nextId = 1;
```

### #3 Prefer Calldata For Array Inputs: EFFECTIVE 0.22% CHEAPER ###

When a function takes an array as input, using `calldata` instead of memory for read-only inputs is cheaper:
```diff
- function generateIds(uint256 numIds, address[] memory owners) external
+ function generateIds(uint256 numIds, address[] calldata owners) external {
```

### #4 Cache Storage To Read & Write Once: EFFECTIVE 0.66% CHEAPER ###

When a storage slot doesn't change it is cheaper to cache the value once then use the cached copy instead of reading it from storage multiple times. Similarly it is cheaper to cache a result during a loop then write the result to storage once than to write to storage during every loop iteration:
```diff
function generateIds(uint256 numIds, address[] calldata owners) external {
    if(numIds != owners.length)
        revert NumIdsOwnersLengthMismatch(numIds, owners.length);

+   @audit read `nextId` from storage once
+   uint256 newId = nextId;

    for(uint256 i; i<numIds; i++) {
-       // read next id from storage
-       uint256 newId = nextId;

        // update the mapping
-       idToOwner[newId] = owners[i];
+       idToOwner[newId++] = owners[i];

-       // update storage to increment next id
-       nextId = newId + 1;
    }

+   // @audit write final `newId` to `nextId` storage once
+   nextId = newId;
```

### #5 Use Delete Instead Of Assignment To Default Value: NOT EFFECTIVE ###

One suggestion is to use the `delete` keyword instead of assigning if the assignment would be to the default value, in order to obtain a gas refund. This appears to not be effective; assignment to the default value results in the same gas cost as using the `delete` keyword:
```solidity
// both implementations cost the same gas
function resetId(uint256 id) external {
    idToOwner[id] = address(0);
}
function resetId(uint256 id) external {
    delete idToOwner[id];
}
```

### #6 Don't Cache Calldata Length: EFFECTIVE 0.09% CHEAPER ###

It is cheaper to not cache `calldata` length:
```diff
function getOwnersForIds(uint256[] calldata ids) external view returns(address[] memory) {
-   // cache length
-   uint256 idsLength = ids.length;

    // allocate output array in memory
-   address[] memory owners = new address[](idsLength);
+   address[] memory owners = new address[](ids.length);

    // populate output array
-   for(uint256 i; i<idsLength; i++) {
+   for(uint256 i; i<ids.length; i++) {
        owners[i] = idToOwner[ids[i]];
    }

    // return output array
    return owners;
}
```

### #7 Use Named Returns: EFFECTIVE 0.14% CHEAPER ###
It is cheaper to use named return variables and remove explicit `return` statements:
```diff
- function getOwnersForIds(uint256[] calldata ids) external view returns(address[] memory) {
+ function getOwnersForIds(uint256[] calldata ids) external view returns(address[] memory owners)
    // allocate output array in memory
-   address[] memory owners = new address[](ids.length);
+   owners = new address[](ids.length);

    // populate output array
    for(uint256 i; i<ids.length; i++) {
        owners[i] = idToOwner[ids[i]];
    }

-    // return output array
-    return owners;
}
```

### #8 Use External Instead Of Public Functions: NOT EFFECTIVE ###
Marking a `public` function as `external` appears to have no effect on gas costs:
```solidity
// both implementations cost the same gas
function resetId(uint256 id) external {
    idToOwner[id] = address(0);
}
function resetId(uint256 id) public {
    idToOwner[id] = address(0);
}
```

### #9 Use `msg.sender` Instead Of `owner()`: EFFECTIVE 0.84% CHEAPER ###
When `msg.sender` is guaranteed to be `owner()` such as inside `onlyOwner` functions, it is cheaper to use `msg.sender`:
```diff
function sendETHToOwner() external virtual onlyOwner {
    uint256 ethBal = address(this).balance;

    if(ethBal > 0) {
-       (bool sent, ) = owner().call{value: ethBal}("");
+       (bool sent, ) = msg.sender.call{value: ethBal}("");
        if(!sent) revert EthTransferFailed();
    }
}
```

### #10 Use `SafeTransferLib::safeTransferETH` Instead Of Solidity `call()`: EFFECTIVE 0.35% CHEAPER ###
When sending ETH, it is cheaper to use Solady's [`safeTransferETH`](https://github.com/Vectorized/solady/blob/main/src/utils/SafeTransferLib.sol#L90-L98) function:
```diff
+ import {SafeTransferLib} from "@solady/utils/SafeTransferLib.sol";

function sendETHToOwner() external virtual onlyOwner {
    uint256 ethBal = address(this).balance;

    if(ethBal > 0) {
-       (bool sent, ) = msg.sender.call{value: ethBal}("");
-       if(!sent) revert EthTransferFailed();
+       SafeTransferLib.safeTransferETH(msg.sender, ethBal);
    }
}
```

### #11 Use `!= 0` Instead Of `> 0` For Unsigned: NOT EFFECTIVE ###
Using `!= 0` or `> 0` costs the same gas providing no benefit:
```solidity
uint256 ethBal = address(this).balance;

// both implementations cost the same gas
if(ethBal > 0)
if(ethBal != 0)
```

### #12 Use Solady `Ownable` Instead of OpenZeppelin: EFFECTIVE 0.03% -> 0.10% CHEAPER ###
Using Solady [`Ownable`](https://github.com/Vectorized/solady/blob/main/src/auth/Ownable.sol) instead of OpenZeppelin resulted in cheaper `onlyOwner` modifier execution by 0.03% with optimizer enabled and 0.10% with optimizer disabled:
```diff
- import {Ownable} from "@openzeppelin/access/Ownable.sol";
+ import {Ownable} from "@solady/auth/Ownable.sol";

- constructor() Ownable(msg.sender) {}
+ constructor() { _initializeOwner(msg.sender); }
```

### #13 Avoid The EIP7201 Trap: EFFECTIVE 9.45% -> 11.86% CHEAPER ###
The [EIP7201](https://eips.ethereum.org/EIPS/eip-7201) Trap occurs when:
* developers get into the habit of constantly calling an internal function to retrieve an EIP7201 storage reference
* re-read the same storage values which haven't changed in throughout multiple child functions.

An example using only 1 storage slot and a call stack based upon one of my private audits did this:
```solidity
- createOrder (2 storage reads)
-- beforeOrderCheck (2 storage reads)
--- beforeOrderCheckParent (1 storage read)
-- _afterOrderCheck (1 storage read)
--- _instantSettlement (1 storage read)
---- _partialSettlement (1 storage read)
```

Each of the above functions was calling the internal function to retrieve an EIP7201 storage reference then re-reading the same storage slot which was never changed during the transaction!

To avoid falling into the EIP7201 Trap, for each major protocol functionality:
* identify which storage slots are not changed but only read for that functionality
* read the storage slots once then pass the cached copies into child functions which also read them

Again using only the 1 storage slot, this produces the following call stack:
```solidity
- createOrder (1 storage read)
-- beforeOrderCheck(cache) (0 storage reads)
--- beforeOrderCheckParent(cache) (0 storage read)
-- _afterOrderCheck(cache) (0 storage read)
--- _instantSettlement(cache) (0 storage read)
---- _partialSettlement(cache) (0 storage read)
```

In our simplied example using only 1 storage slot the gas costs was 9.45% cheaper with optimizer enabled and 11.86% cheaper without the optimizer. In real-world protocols where multiple storage slots are not changed but frequently read the gas savings are likely to be even greater.