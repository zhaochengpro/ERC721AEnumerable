// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "../ERC721A.sol";
import "../utils/EnumerableSet.sol";

contract ERC721AEnumerable is ERC721A {
    using EnumerableSet for EnumerableSet.UintSet;

    mapping(address => EnumerableSet.UintSet) private _tokenIdsOf;

    constructor(string memory _name, string memory _symbol)
        ERC721A(_name, _symbol)
    {}

    function tokenIdsOf(address account) public view returns (uint256[] memory) {
        return _tokenIdsOf[account].values();
    }

    function _addTokenIdForOwner(address owner, uint256 tokenId) internal {
        _tokenIdsOf[owner].add(tokenId);
    }

    function _removeTokenIdForOwner(address owner, uint256 tokenId) internal {
        _tokenIdsOf[owner].remove(tokenId);
    }

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal override virtual {
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = startTokenId + i;
            _removeTokenIdForOwner(from, tokenId);
            _addTokenIdForOwner(to, tokenId);
        }
    }
}
