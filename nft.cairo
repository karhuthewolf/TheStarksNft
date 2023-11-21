// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.5.0 (token/erc721/enumerable/presets/ERC721EnumerableMintableBurnable.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, assert_uint256_le
from starkware.cairo.common.alloc import alloc
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable
from openzeppelin.security.safemath.library import SafeUint256
from starkware.cairo.common.bool import FALSE, TRUE

//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt
) {
    ERC721.initializer('The Starks', 'STK');
    ERC721Enumerable.initializer();
    Ownable.initializer(owner);
    counteur.write(Uint256(1, 0));
    maxSupply.write(Uint256(6, 0));
    isWhitelistMintLive.write(FALSE);
    isMintLive.write(FALSE);
    whitelistPrice.write(Uint256(0, 0));
    normalPrice.write(Uint256(0, 0));
    return ();
}

@storage_var
func maxSupply() -> (res: Uint256) {
}

@storage_var
func counteur() -> (res: Uint256) {
}

@storage_var
func whitelistPrice() -> (res: Uint256) {
}

@storage_var
func normalPrice() -> (res: Uint256) {
}

@storage_var
func isWhitelistMintLive() -> (res: felt) {
}

@storage_var
func isMintLive() -> (res: felt) {
}

@storage_var
func ERC721baseUri(index: felt) -> (char: felt) {
}

@storage_var
func ERC721baseUri_len() -> (res: felt){
}

@storage_var
func ERC721contractUri(index: felt) -> (char: felt) {
}

@storage_var
func ERC721contractUri_len() -> (res: felt){
}

@storage_var
func whitelist(adrs: felt) -> (res: felt) {
}

@storage_var
func royaltiesReceiver() -> (res: felt) {
}

@storage_var
func royaltiesAmount() -> (res: Uint256) {
}

//
// Getters
//

@view
func totalSupply{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
    totalSupply: Uint256
) {
    let (totalSupply: Uint256) = ERC721Enumerable.total_supply();
    return (totalSupply=totalSupply);
}

@view
func tokenByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    index: Uint256
) -> (tokenId: Uint256) {
    let (tokenId: Uint256) = ERC721Enumerable.token_by_index(index);
    return (tokenId=tokenId);
}

@view
func tokenOfOwnerByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    owner: felt, index: Uint256
) -> (tokenId: Uint256) {
    let (tokenId: Uint256) = ERC721Enumerable.token_of_owner_by_index(owner, index);
    return (tokenId=tokenId);
}

@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    return ERC165.supports_interface(interfaceId);
}

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    return ERC721.name();
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    return ERC721.symbol();
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) -> (
    balance: Uint256
) {
    return ERC721.balance_of(owner);
}

@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    owner: felt
) {
    return ERC721.owner_of(tokenId);
}

@view
func getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (approved: felt) {
    return ERC721.get_approved(tokenId);
}

@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, operator: felt
) -> (isApproved: felt) {
    let (isApproved: felt) = ERC721.is_approved_for_all(owner, operator);
    return (isApproved=isApproved);
}

// @view
// func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
//     tokenId: Uint256, index: felt
// ) -> (tokenURI: felt) {
//     let (tokenURI: felt) = ERC721baseUri.read(index);
//     return (tokenURI=tokenURI);
// }

@view
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        tokenId: Uint256
) -> (baseUri_len: felt, baseUri: felt*) {
        alloc_locals;
        let (local baseUri) = alloc();
        let (local baseUri_len) = ERC721baseUri_len.read();
        _loopGetBaseUri(baseUri_len, baseUri);
        return (baseUri_len, baseUri);
}

func _loopGetBaseUri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    baseUri_len: felt, baseUri: felt*
) {
    if (baseUri_len == 0) {
        return ();
    }

    let (char) = ERC721baseUri.read(baseUri_len);
    assert [baseUri] = char;
    _loopGetBaseUri(baseUri_len - 1, baseUri + 1);
    return ();
}

@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

@view
func contractUri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    contractUri_len: felt, contractUri: felt*
) {
    alloc_locals;
    let (local contractUri) = alloc();
    let (local contractUri_len) = ERC721contractUri_len.read();
    _loopGetContractUri(contractUri_len, contractUri);
    return (contractUri_len, contractUri);
}

func _loopGetContractUri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    contractUri_len: felt, contractUri: felt*
) {
    if (contractUri_len == 0) {
        return ();
    }

    let (char) = ERC721contractUri.read(contractUri_len);
    assert [contractUri] = char;
    _loopGetContractUri(contractUri_len - 1, contractUri + 1);
    return ();
}

@view
func royaltyInfo{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256, salePrice: Uint256) -> (
    receiver: felt, royaltyAmount: Uint256
) {
    let (receiver: felt) = royaltiesReceiver.read();
    let (royaltyAmount: Uint256) = royaltiesAmount.read();
    return(receiver, royaltyAmount);
}

//
// Externals
//

@external
func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    ERC721.approve(to, tokenId);
    return ();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC721.set_approval_for_all(operator, approved);
    return ();
}

@external
func transferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256
) {
    ERC721Enumerable.transfer_from(from_, to, tokenId);
    return ();
}

@external
func safeTransferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
) {
    ERC721Enumerable.safe_transfer_from(from_, to, tokenId, data_len, data);
    return ();
}

@external
func addWhitelisted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) {
    Ownable.assert_only_owner();
    whitelist.write(account, TRUE);
    return ();
}

@external
func addWhitelistArray{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    accounts_len: felt, accounts: felt
) {
    Ownable.assert_only_owner();
    whitelist.write(account, TRUE);
    return ();
}

@external
func removeWhitelisted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) {
    Ownable.assert_only_owner();
    whitelist.write(account, FALSE);
    return ();
}

@external
func setContractURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    contractUri_len: felt, contractUri: felt*
) {
    Ownable.assert_only_owner();
    _loopSetContractUri(contractUri_len, contractUri);
    return ();
}

func _loopSetContractUri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    contractUri_len: felt, contractUri: felt*
) {
    if (contractUri_len == 0) {
        return ();
    }

    ERC721contractUri.write(contractUri_len, [contractUri]);
    _loopSetContractUri(contractUri_len - 1, contractUri + 1);
    return ();
}

@external
func setBaseURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    baseUri_len: felt, baseUri: felt*
) {
    Ownable.assert_only_owner();
    _loopSetBaseUri(baseUri_len, baseUri);
    return ();
}

func _loopSetBaseUri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    baseUri_len: felt, baseUri: felt*
) {
    if (baseUri_len == 0) {
        return ();
    }

    ERC721baseUri.write(baseUri_len, [baseUri]);
    _loopSetBaseUri(baseUri_len - 1, baseUri + 1);
    return ();
}

@external
func whitelistMint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt) {
    let (isWhitelisted: felt) = whitelist.read(to);
    assert isWhitelisted = TRUE;
    let (isWhitelistMintLiveLocal: felt) = isWhitelistMintLive.read();
    assert isWhitelistMintLiveLocal = TRUE;
    let (tokenId: Uint256) = counteur.read();
    let (maxTokenId: Uint256) = maxSupply.read();
    assert_uint256_le(tokenId, maxTokenId);
    let (newCounteur: Uint256) = SafeUint256.add(tokenId, Uint256(1, 0));
    counteur.write(newCounteur);
    ERC721Enumerable._mint(to, tokenId);
    return ();
}

@external
func mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt) {
    let (isMintLiveLocal: felt) = isMintLive.read();
    assert isMintLiveLocal = TRUE;
    let (tokenId: Uint256) = counteur.read();
    let (maxTokenId: Uint256) = maxSupply.read();
    assert_uint256_le(tokenId, maxTokenId);
    let (newCounteur: Uint256) = SafeUint256.add(tokenId, Uint256(1, 0));
    counteur.write(newCounteur);
    ERC721Enumerable._mint(to, tokenId);
    return ();
}

@external
func ownerMint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt) {
    Ownable.assert_only_owner();
    let (tokenId: Uint256) = counteur.read();
    let (maxTokenId: Uint256) = maxSupply.read();
    assert_uint256_le(tokenId, maxTokenId);
    let (newCounteur: Uint256) = SafeUint256.add(tokenId, Uint256(1, 0));
    counteur.write(newCounteur);
    ERC721Enumerable._mint(to, tokenId);
    return ();
}

@external
func startWhitelistMint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
) {
    Ownable.assert_only_owner();
    isWhitelistMintLive.write(TRUE);
    return ();
}

@external
func startMint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
) {
    Ownable.assert_only_owner();
    isWhitelistMintLive.write(FALSE);
    isMintLive.write(TRUE);
    return ();
}

@external
func endMint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
) {
    Ownable.assert_only_owner();
    isWhitelistMintLive.write(FALSE);
    isMintLive.write(FALSE);
    return ();
}

@external
func setWhitelistPrice{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    price: Uint256
) {
    Ownable.assert_only_owner();
    whitelistPrice.write(price);
    return ();
}

@external
func setNormalPrice{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    price: Uint256
) {
    Ownable.assert_only_owner();
    normalPrice.write(price);
    return ();
}


@external
func burn{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(tokenId: Uint256) {
    ERC721.assert_only_token_owner(tokenId);
    ERC721Enumerable._burn(tokenId);
    return ();
}

@external
func setMaxSupply{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    newMaxSupply: Uint256
) {
    Ownable.assert_only_owner();
    maxSupply.write(newMaxSupply);
    return ();
}

@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}