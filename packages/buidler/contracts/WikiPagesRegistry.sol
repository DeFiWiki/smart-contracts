pragma solidity >=0.8.0 <0.9.0;

//SPDX-License-Identifier: MIT

contract WikiPagesRegistry {
    // registry of wikiPages
    // TODO create contract => only governance
    // TODO create contract => only oracle

    // Every section should be always at the same place in the array, this makes it intelligable for the FE.
    // e.g. FE knows that TVL is always at position 5, so it can ask only for this for all wiki pages

    // pages => sectionHashes
    // pages start from 2.nd place => position 1
    string[][] public wikiPages;

    struct SectionMetadata {
        string wikiPageName;
        string sectionName;
        string currentHash;
        string previousHash;
        address sectionMaintainer;
    }

    mapping(string => uint256) public pagePositionInArray;
    mapping(string => uint256) public lastSectionInArray;
    mapping(string => bool) public pageExists;
    mapping(string => address) public pageSectionMaintainer; //  sectionHash => managerAddres !!! probably incorrect, if two sections can have same hashes, possible collusion
    mapping(string => SectionMetadata) public getSectionMetadata; // section hash => section metadata
    mapping(string => string) public getPreviousHash;

    constructor() {
        // this is neccessary for the mappings not to be confusing, they return 0 if no value,
        // so if array starts from 0 it is confusing
        wikiPages.push(["Empty page, wikiPages start at position 1"]);
    }

    function sectionExists(string memory _hash) public view returns (bool) {
        if (pageSectionMaintainer[_hash] != address(0)) {
            return true;
        } else {
            return false;
        }
    }

    // !! only governance
    function createSectionMetadata(
        string memory _wikiPageName,
        string memory _sectionName,
        string memory _currentHash,
        address _sectionMaintainer
    ) public {
        // checks if section has unique hash => unique content
        require(!sectionExists(_currentHash), "section already exists");
        // checks if wiki page exists
        require(pagePositionInArray[_wikiPageName] != 0);

        // SectionMetadata
        SectionMetadata memory section = SectionMetadata(
            _wikiPageName,
            _sectionName,
            _currentHash,
            "",
            _sectionMaintainer
        );
        getSectionMetadata[_currentHash] = section;
    }

    // !! only governance
    function addNewPage(
        string memory _wikiPageName,
        string[] memory _sectionHashes
    ) external {
        // check if page does not already exists
        require(!pageExists[_wikiPageName], "wiki_page_does_already_exist");

        for (uint256 i = 0; i < _sectionHashes.length; i++) {
            // checks if section has unique hash => unique content
            require(
                !sectionExists(_sectionHashes[i]),
                "section already exists"
            );
            // adds placeholder maintainer for sections, this is necessary not to break fn sectionExists
            pageSectionMaintainer[
                _sectionHashes[i]
            ] = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
        }

        // creates new page in array + writes section hashes
        //// section hashes
        wikiPages.push(_sectionHashes);

        // wikiPage position pages start from position 1
        pagePositionInArray[_wikiPageName] = wikiPages.length - 1;

        //set last section in array
        lastSectionInArray[_wikiPageName] = _sectionHashes.length - 1;

        // updates array
        pageExists[_wikiPageName] = true;

        // // this could be empty if we just create page and allow users to challenge sections
        // // there are no maintainers needed, anybody can challenge content and become one
        // // problem could be, that if not set in advance, there could be a fight for becoming one
        // setpageSectionMaintainer(_wikiPage, _newmaintainer);

        // sets page exists
    }

    // Every section should be always at the same place in the array, this makes it intelligable for the FE.
    // e.g. FE knows that TVL is always at position 5, so it can ask only for this for all wiki pages

    // IMPORTANT: push new Sections always to their alloted place in the section array
    // If the next section is empty, push empty element into array

    // IMPORTANT: content of each section needs to be unique => it is REQUIRED to put wikiName

    // TODO only governance
    function addNewSections(
        string memory _wikiPageName,
        string[] memory _newSectionHashes
    ) public {
        // checks if wiki does not yet exists
        require(
            pagePositionInArray[_wikiPageName] != 0,
            "wiki page does not exist"
        );

        uint256 pagePosition = pagePositionInArray[_wikiPageName];

        for (uint256 i = 0; i < _newSectionHashes.length; i++) {
            // checks if section has unique hash => unique content
            require(
                !sectionExists(_newSectionHashes[i]),
                "section already exists"
            );
            wikiPages[pagePosition].push(_newSectionHashes[i]);
            // adds placeholder maintainer for sections, this is necessary not to break fn sectionExists
            pageSectionMaintainer[
                _newSectionHashes[i]
            ] = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
        }

        // wikiPages[pagePosition].push(_newSectionHashes);
        //
        // set last section in array
        lastSectionInArray[_wikiPageName] = wikiPages[pagePosition].length - 1;
    }

    // ADD Only Oracle
    function changeMaintainer(
        uint256 _pagePositionInArray,
        uint256 _sectionPositionInArray,
        address _newMaintainer
    ) public returns (bool) {
        string memory sectionHash = wikiPages[_pagePositionInArray][
            _sectionPositionInArray
        ];
        pageSectionMaintainer[sectionHash] = _newMaintainer;
        return true;
    }

    function updateSection(
        uint256 _pagePositionInArray,
        uint256 _sectionPositionInArray,
        string memory _newSectionHash
    ) external returns (bool) {
        // checks if msg.sender == sectionMaintainer
        require(
            msg.sender ==
                pageSectionMaintainer[
                    wikiPages[_pagePositionInArray][_sectionPositionInArray]
                ],
            "you are not maintainer for this section"
        );
        // checks if section has unique hash => unique content
        require(
            !sectionExists(_newSectionHash),
            "section already exists, please include metadata"
        );
        // get hash which to update
        string memory oldHash = wikiPages[_pagePositionInArray][
            _sectionPositionInArray
        ];
        // changes hash in array
        wikiPages[_pagePositionInArray][
            _sectionPositionInArray
        ] = _newSectionHash;
        // updates mapping pageSectionMaintainer
        pageSectionMaintainer[_newSectionHash] = msg.sender;
        // update mapping getPreviousHash
        getPreviousHash[_newSectionHash] = oldHash;

        // TODO update section metadata
        return true;
    }

    function getNumOfPages() public view returns (uint256) {
        return wikiPages.length - 1;
    }
}
