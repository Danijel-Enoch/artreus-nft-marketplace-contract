// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.7.0 <0.9.0;

contract AtreusCollection is ERC721Enumerable, Ownable {
    using Strings for uint256;
    string baseURI;
    string public baseExtension = ".json";
    uint256 public maxSupply = 50;
    uint256 public batchMintPrice=5 ether;
    uint256 public mintFrom;
    address public treasury;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        uint256 _mintFrom,
        address _treasury
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
    mintFrom=_mintFrom;
    treasury=_treasury;
       // batchMint(_mintFrom);
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function batchMint(uint256 _amountToMint)public payable{
        require(_amountToMint<=maxSupply,"You can't mint pass 50 NFts");
        require(msg.value!=batchMintPrice,"You are paying the wrong mint amount");
        payable(treasury).transfer(address(this).balance);
        uint256 mintStopPoint=maxSupply;
          for (uint i = 0; i < mintStopPoint; i++) {
                 mint(mintFrom) ;
        }
    }

    // public
    function mint(uint256 _mintFrom) private  {
        uint256 supply = totalSupply();
        require(supply <= maxSupply);
        _safeMint(msg.sender, _mintFrom+supply + 1);
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    // Only owner
   

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

}