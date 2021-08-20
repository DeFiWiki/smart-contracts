<<<<<<< HEAD
// pragma solidity >=0.8.0 <0.9.0;

// //SPDX-License-Identifier: MIT

// contract WikiPagesRegistry {
//     // registry of wikiPages
//     // TODO create contract => only governance
//     // TODO create contract => only oracle

//     // Every section should be always at the same place in the array, this makes it intelligable for the FE.
//     // e.g. FE knows that TVL is always at position 5, so it can ask only for this for all wiki pages

//     string currentHash;

//     struct SectionMetadata {
//         string currentHash;
//         string previousHash;
//         string sectionName;
//     }

//     // pages => sectionHashes
//     // pages start from 2.nd place => position 1
//     SectionMetadata[][] public wikiPages;

//     SectionMetadata public previousMetada =
//         SectionMetadata("hash1", "hash0", "content");
//     SectionMetadata public currentMetada =
//         SectionMetadata("hash2", "hash1", "content");

//     mapping(string => uint256) public pagePositionInArray;
//     mapping(string => uint256) public lastSectionInArray;
//     // mapping(string => bool) public pageExists;
//     mapping(string => address) public pageSectionMaintainer; //  sectionHash => managerAddres
//     mapping(string => string) public getPreviousHash; //
//     mapping(string => string) public getSectionMetadate;  //
//     mapping(string => SectionMetadata) public getPreviousMetadata; // new section hash => old metadata

//     // function get(string memory _currrentSectionHash) public view returns (calldata SectionMetadata) {
//     //      // Mapping always returns a value.
//     //      // If the value was never set, it will return the default value.
//     //     return getPreviousMetadata[_currrentSectionHash];
//     // }

//     function setPreviousMetadata(string memory _newHash) public {
//         // Mapping always returns a value.
//         // If the value was never set, it will return the default value.

//         // get latest hash

//         getPreviousMetadata[_newHash] = currentMetada;
//     }

//     // function createElement(string memory _currentHash,  string memory _previousHash, string memory _sectionName) public returns (memory SectionMetadata) {
//     //     SectionMetadata memory element;
//     //     element.currentHash = _currentHash;
//     //     element.previousHash = _previousHash;
//     //     element.sectionName = _sectionName;
//     //     return element;
//     // }

//     constructor() {
//         // this is neccessary for the mappings not to be confusing, they return 0 if no value,
//         // so if array starts from 0 it is confusing
//         SectionMetadata memory element = SectionMetadata(
//             "",
//             "",
//             "Empty page, wikiPages start at position 1"
//         );
//         // element.currentHash = "";
//         // element.previousHash = "";
//         // element.sectionName = "Empty page, wikiPages start at position 1";
//         wikiPages.push([element]);
//     }

//     // !! only governance
//     function addNewPage(
//         string memory _wikiPageName,
//         string[] memory _sectionHashes
//     ) external {
//         // // check if page does not already exists
//         // require(!pagePositionInArray[_wikiPageName] != 0, "wiki_page_does_already_exist");

//         // creates new page in array + writes section hashes
//         //// section hashes
//         SectionMetadata memory element = SectionMetadata(
//             "",
//             "",
//             "_wikiPageName"
//         );
//         wikiPages.push(_sectionHashes);

//         // wikiPage position pages start from position 1
//         pagePositionInArray[_wikiPageName] = wikiPages.length - 1;

//         //set last section in array
//         lastSectionInArray[_wikiPageName] = _sectionHashes.length - 1;

//         // // updates array
//         // pageExists[_wikiPageName] = true;

//         // // this could be empty if we just create page and allow users to challenge sections
//         // // there are no maintainers needed, anybody can challenge content and become one
//         // // problem could be, that if not set in advance, there could be a fight for becoming one
//         // setpageSectionMaintainer(_wikiPage, _newmaintainer);

//         // sets page exists
//     }

//     // Every section should be always at the same place in the array, this makes it intelligable for the FE.
//     // e.g. FE knows that TVL is always at position 5, so it can ask only for this for all wiki pages

//     // IMPORTANT: push new Sections always to their alloted place in the section array
//     // If the next section is empty, push empty element into array

//     // IMPORTANT: content of each section needs to be unique => it is REQUIRED to put wikiName

//     // TODO only governance
//     function addNewSections(
//         string memory _wikiPageName,
//         string[] memory _newSectionHashes
//     ) public {
//         uint256 pagePosition = pagePositionInArray[_wikiPageName];

//         for (uint256 i = 0; i < _newSectionHashes.length; i++) {
//             wikiPages[pagePosition].push(_newSectionHashes[i]);
//         }

//         // wikiPages[pagePosition].push(_newSectionHashes);
//         //
//         // set last section in array
//         lastSectionInArray[_wikiPageName] = wikiPages[pagePosition].length - 1;
//     }

//     // ADD Only Oracle
//     function changeMaintainer(
//         uint256 _pagePositionInArray,
//         uint256 _sectionPositionInArray,
//         address _newMaintainer
//     ) public returns (bool) {
//         string memory sectionHash = wikiPages[_pagePositionInArray][
//             _sectionPositionInArray
//         ];
//         pageSectionMaintainer[sectionHash] = _newMaintainer;
//         return true;
//     }

//     function updateSection(
//         uint256 _pagePositionInArray,
//         uint256 _sectionPositionInArray,
//         string memory _newSectionHash
//     ) external returns (bool) {
//         // checks if msg.sender == sectionMaintainer
//         require(
//             msg.sender ==
//                 pageSectionMaintainer[
//                     wikiPages[_pagePositionInArray][_sectionPositionInArray]
//                 ],
//             "you are not maintainer for this section"
//         );
//         //   require(_newSectionHash != wikiPages[_pagePositionInArray][_sectionPositionInArray], "this section already exists");
//         wikiPages[_pagePositionInArray][
//             _sectionPositionInArray
//         ] = _newSectionHash;
//         return true;
//     }

//     function getNumOfPages() public view returns (uint256) {
//         return wikiPages.length - 1;
//     }
// }
=======
pragma solidity >=0.8.0 <0.9.0;

//SPDX-License-Identifier: MIT

contract WikiPagesRegistry {
    // registry of wikiPages
    // TODO create contract => only governance
    // TODO create contract => only oracle

    // Every section should be always at the same place in the array, this makes it intelligable for the FE.
    // e.g. FE knows that TVL is always at position 5, so it can ask only for this for all wiki pages

    string currentHash;

    struct SectionMetadata {
        string currentHash;
        string previousHash;
        string sectionName;
    }

    // pages => sectionHashes
    // pages start from 2.nd place => position 1
    SectionMetadata[][] public wikiPages;

    SectionMetadata public previousMetada =
        SectionMetadata("hash1", "hash0", "content");
    SectionMetadata public currentMetada =
        SectionMetadata("hash2", "hash1", "content");

    mapping(string => uint256) public pagePositionInArray;
    mapping(string => uint256) public lastSectionInArray;
    // mapping(string => bool) public pageExists;
    mapping(string => address) public pageSectionMaintainer; //  sectionHash => managerAddres
    mapping(string => string) public getPreviousHash; //
    mapping(string => string) public getSectionMetadate;
    mapping(string => SectionMetadata) public getPreviousMetadata; // new section hash => old metadata

    // function get(string memory _currrentSectionHash) public view returns (calldata SectionMetadata) {
    //      // Mapping always returns a value.
    //      // If the value was never set, it will return the default value.
    //     return getPreviousMetadata[_currrentSectionHash];
    // }

    function setPreviousMetadata(string memory _newHash) public {
        // Mapping always returns a value.
        // If the value was never set, it will return the default value.

        // get latest hash

        getPreviousMetadata[_newHash] = currentMetada;
    }

    // function createElement(string memory _currentHash,  string memory _previousHash, string memory _sectionName) public returns (memory SectionMetadata) {
    //     SectionMetadata memory element;
    //     element.currentHash = _currentHash;
    //     element.previousHash = _previousHash;
    //     element.sectionName = _sectionName;
    //     return element;
    // }

    constructor() {
        // this is neccessary for the mappings not to be confusing, they return 0 if no value,
        // so if array starts from 0 it is confusing
        SectionMetadata memory element = SectionMetadata(
            "",
            "",
            "Empty page, wikiPages start at position 1"
        );
        // element.currentHash = "";
        // element.previousHash = "";
        // element.sectionName = "Empty page, wikiPages start at position 1";
        wikiPages.push([element]);
    }

    // !! only governance
    function addNewPage(
        string memory _wikiPageName,
        string[] memory _sectionHashes
    ) external {
        // // check if page does not already exists
        // require(!pagePositionInArray[_wikiPageName] != 0, "wiki_page_does_already_exist");

        // creates new page in array + writes section hashes
        //// section hashes
        SectionMetadata memory element = SectionMetadata(
            "",
            "",
            "_wikiPageName"
        );
        wikiPages.push(_sectionHashes);

        // wikiPage position pages start from position 1
        pagePositionInArray[_wikiPageName] = wikiPages.length - 1;

        //set last section in array
        lastSectionInArray[_wikiPageName] = _sectionHashes.length - 1;

        // // updates array
        // pageExists[_wikiPageName] = true;

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
        uint256 pagePosition = pagePositionInArray[_wikiPageName];

        for (uint256 i = 0; i < _newSectionHashes.length; i++) {
            wikiPages[pagePosition].push(_newSectionHashes[i]);
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
        //   require(_newSectionHash != wikiPages[_pagePositionInArray][_sectionPositionInArray], "this section already exists");
        wikiPages[_pagePositionInArray][
            _sectionPositionInArray
        ] = _newSectionHash;
        return true;
    }

    function getNumOfPages() public view returns (uint256) {
        return wikiPages.length - 1;
    }
}
>>>>>>> 78c2c6d2018a9e9d3fc4e247bc577bab6a40de3c
