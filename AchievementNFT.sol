// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AchievementNFT - tradeable achievement NFTs (minimal ERC-721 style)
/// @notice No imports, no constructor, no input fields. Call initializeAdmin once after deployment.
contract AchievementNFT {
    // --- ERC-721 metadata (constants so no constructor needed) ---
    string public constant name = "Achievements";
    string public constant symbol = "ACHV";

    // --- Admin (set once via initializeAdmin) ---
    address public admin;
    bool private adminInitialized;

    // --- ERC-721 storage ---
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => bool) private _exists;

    // --- Events ---
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event AchievementMinted(address indexed to, uint256 indexed tokenId, string uri);

    // --- Modifiers ---
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    // --- Admin initialization (no constructor allowed) ---
    /// @notice Initialize the admin once after deployment
    function initializeAdmin(address _admin) external {
        require(!adminInitialized, "Admin already initialized");
        require(_admin != address(0), "Invalid admin");
        admin = _admin;
        adminInitialized = true;
    }

    // --- ERC-721 read functions ---
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "token does not exist");
        return owner;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists[tokenId], "token does not exist");
        return _tokenURIs[tokenId];
    }

    // --- Approval / operator ---
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "approval to current owner");
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "not authorized");
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists[tokenId], "token does not exist");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(operator != msg.sender, "operator is caller");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    // --- Transfer helpers ---
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not approved or owner");
        require(ownerOf(tokenId) == from, "from not owner");
        require(to != address(0), "transfer to zero");

        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    // --- Safe transfer (basic) ---
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        transferFrom(from, to, tokenId);
        _checkOnERC721Received(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
        transferFrom(from, to, tokenId);
        _checkOnERC721Received(from, to, tokenId, data);
    }

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    // --- Minting (admin only) ---
    function mintAchievement(address to, uint256 tokenId, string memory uri) public onlyAdmin {
        require(to != address(0), "mint to zero");
        require(!_exists[tokenId], "token exists");

        _owners[tokenId] = to;
        _balances[to] += 1;
        _exists[tokenId] = true;
        _tokenURIs[tokenId] = uri;

        emit Transfer(address(0), to, tokenId);
        emit AchievementMinted(to, tokenId, uri);
    }

    function batchMintAchievements(address[] memory tos, uint256[] memory tokenIds, string[] memory uris) external onlyAdmin {
        require(tos.length == tokenIds.length && tokenIds.length == uris.length, "length mismatch");
        for (uint256 i = 0; i < tos.length; ++i) {
            mintAchievement(tos[i], tokenIds[i], uris[i]);
        }
    }

    // --- Burn (owner or approved) ---
    function burn(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_isApprovedOrOwner(msg.sender, tokenId), "not approved or owner");

        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];
        delete _tokenURIs[tokenId];
        _exists[tokenId] = false;

        emit Transfer(owner, address(0), tokenId);
    }

    // --- Receiver check (fixed) ---
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private {
        if (isContract(to)) {
            (bool success, bytes memory returndata) = to.call(
                abi.encodeWithSelector(
                    0x150b7a02, // onERC721Received selector
                    msg.sender,
                    from,
                    tokenId,
                    data
                )
            );
            if (success && returndata.length >= 4) {
                bytes4 retval = abi.decode(returndata, (bytes4));
                require(retval == _ERC721_RECEIVED, "unsafe recipient");
            } else {
                revert("unsafe recipient");
            }
        }
    }

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    // --- Admin utilities ---
    function changeAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "zero admin");
        admin = newAdmin;
    }

    function exists(uint256 tokenId) external view returns (bool) {
        return _exists[tokenId];
    }
}

