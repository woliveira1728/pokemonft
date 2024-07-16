// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PokemoNFT is ERC721 {

    struct Pokemon{
        string name;
        uint level;
        string img;
    }

    Pokemon[] public pokemons;
    address public gameOwner;

    constructor() ERC721 ("PokemoNFT", "PKNFT") {
        gameOwner = msg.sender;
    }

    modifier onlyOwnerOf(uint _mosterid) {
        require(ownerOf(_mosterid) == msg.sender, "Only the owner can battle this pokemon");
        _;
    }

    function battle(uint _attachingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attachingPokemon){
        Pokemon storage attacker = pokemons[_attachingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];
        
        if(attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Only the owner can create new pokemons");
        uint id = pokemons.length;
        pokemons.push(Pokemon(_name, 1, _img));
        _safeMint(_to, id);
    }

}