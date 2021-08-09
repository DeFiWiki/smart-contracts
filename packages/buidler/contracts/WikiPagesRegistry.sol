pragma solidity >=0.8.0 <0.9.0;

//SPDX-License-Identifier: MIT

contract WikiPagesRegistry {
    //   string streamId;
    //   uint counter = 0;
    //   struct wikiPage {
    //       string section1;
    //       string section2;
    //       string section3;
    //       string section4;
    //       string section5;
    //       string section6;
    //       string section7;
    //       string section8;
    //       string section9;
    //       string section10;

    //   }

    // registry fo wiki addresses
    // TODO only governance updates
    // pages => sectionHashes
    string[][] public wikiPages;

    // how many sections does wikipage have
    // TODO only governance updates
    mapping(string => uint256) public numOfSections;
    mapping(string => bool) public pageExists;
    mapping(string => address) public pageSectionMaintainer;

    function getNumOfPages() public returns (uint256) {
        return wikiPages.length;
    }

    // TODO only governance
    function updateNumOfSections() public {}

    // string[] public simplePagesArray;

    // // check if wiki page exists
    // function pageExists(string memory _wikiPage)
    //     public
    //     view
    //     returns (bool)
    // {
    //     if (bytes(wikiPageStreamId[_wikiPage]).length != 0) {
    //         return true;
    //     }
    //     return false;
    // }

    // !! only governance
    function addNewPage(
        string memory _wikiPageName,
        address _newmaintainer,
        uint32 _num
    ) external {
        // check if page does not already exists
        require(!pageExists[_wikiPageName], "wiki_page_does_already_exist");

        // creates new page in array + writes section hashes
        simplePagesArray.push(_wikiPage);

        //

        //set number of sections

        // sets maintainer for each section
        setpageSectionMaintainer(_wikiPage, _newmaintainer);

        // sets page exists
    }

    function createSectionArrayForPage() external returns (string[] storage) {
        // creates array for new Page
        hashes[];
    }

    // if wikPage exists replace array
    //   // if not add to array
    //   // create double mappings?

    //   // change maintainer
    //   function changemaintainer(string memory _wikiPage, string memory _maintainerId) public returns (bool) {
    //       pagePosition = wikiPagePosition[_wikiPage];
    //       // page does not exists
    //       if(pagePosition == 0) {
    //           // create new array
    //       } else {
    //           // change array at specified position
    //           wikiRegistry[counter].streamId = _streamId;
    //           wikiRegistry[pagePosition].wikiPage = _wikiPage;

    //       }

    //   }
    //   // if page exists, overwrite array
    //   // if not, create new array => need mapping that returns position in array.

    // !! change to internal
    function setpageSectionMaintainer(string memory _wikiPage, address _addr)
        internal
    {
        pageSectionMaintainer[_wikiPage] = _addr;
    }

    // // !! change to internal
    // function setWikiPageStreamId(
    //     string memory _wikiPage,
    //     string memory _streamId
    // ) internal {
    //     // Update the value at this address
    //     wikiPageStreamId[_wikiPage] = _streamId;
    // }

    // function setWikiPagePosition(string memory _wikiPage, uint256 _position)
    //     internal
    // {
    //     // Update the value at this address
    //     wikiPagePosition[_wikiPage] = _position;
    // }

    // !! add only governance
    function changemaintainer(address _newmaintainer, string memory _wikiPage)
        external
        returns (bool)
    {
        // require(
        //     pageExists(_wikiPage) && _newmaintainer != address(0),
        //     "wiki_page_does_not_exist"
        // );
        setpageSectionMaintainer(_wikiPage, _newmaintainer);

        // checks if maintainer is set to new owner
        address newmaintainer = pageSectionMaintainer[_wikiPage];
        if (newmaintainer == _newmaintainer) {
            return true;
        }
        return false;
    }
}
