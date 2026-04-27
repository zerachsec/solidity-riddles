// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Overmint1 is
    ERC721 // contract Overmint1 is ERC721, ReentrancyGuard {
{
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor() ERC721("Overmint1", "AT") {}

    function mint() external {
        //nonReentrant
        require(amountMinted[msg.sender] <= 3, "max 3 NFTs"); //it should be < 3
        //At first glance it looks fine, but combined with _safeMint, it becomes vulnerable.
        totalSupply++;
        _safeMint(msg.sender, totalSupply); //Reentrancy (via ERC721 receiver hook) | Logic flaw in mint limit enforcement
        amountMinted[msg.sender]++;
    }

    // fix ✅
    function mint() external {
        require(amountMinted[msg.sender] < 3, "max 3 NFTs");

        amountMinted[msg.sender]++; // ✅ move this up
        totalSupply++;

        _safeMint(msg.sender, totalSupply);
    }

    function success(address _attacker) external view returns (bool) {
        return balanceOf(_attacker) == 5;
    }
}
