pragma solidity >=0.8.0 <0.9.0;

//SPDX-License-Identifier: MIT

contract WikiPagesRegistry {
    //   string streamId;
    //   uint counter = 0;
    //   struct wikiPage {
    //       string streamId;
    //       string wikiPage;
    //   }

    // registry fo wiki addresses
    // wikiPage[100] public wikiPages;

    string[] public simplePagesArray;

    mapping(string => address) public wikiPageController;

    mapping(string => string) public wikiPageStreamId;

    mapping(string => uint256) public wikiPagePosition;

    // check if wiki page exists
    function wikiPageExists(string memory _wikiPage)
        public
        view
        returns (bool)
    {
        if (bytes(wikiPageStreamId[_wikiPage]).length != 0) {
            return true;
        }
        return false;
    }

    // if wikPage exists replace array
    //   // if not add to array
    //   // create double mappings?

    //   // change controller
    //   function changeController(string memory _wikiPage, string memory _controllerId) public returns (bool) {
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
    function setwikiPageController(string memory _wikiPage, address _addr)
        internal
    {
        wikiPageController[_wikiPage] = _addr;
    }

    // !! change to internal
    function setWikiPageStreamId(
        string memory _wikiPage,
        string memory _streamId
    ) internal {
        // Update the value at this address
        wikiPageStreamId[_wikiPage] = _streamId;
    }

    function setWikiPagePosition(string memory _wikiPage, uint256 _position)
        internal
    {
        // Update the value at this address
        wikiPagePosition[_wikiPage] = _position;
    }

    // !! only governance
    function addNewPage(
        string memory _wikiPage,
        address _newController,
        string memory _streamId
    ) external {
        // check if page does not already exists
        require(!wikiPageExists(_wikiPage), "wiki_page_does_already_exist");

        // creates new element in array
        simplePagesArray.push(_wikiPage);

        //set wiki page position
        uint256 _position = simplePagesArray.length;
        setWikiPagePosition(_wikiPage, _position);

        // sets controller
        setwikiPageController(_wikiPage, _newController);

        // sets stream
        setWikiPageStreamId(_wikiPage, _streamId);
    }

    // !! add only owner
    function changeController(address _newController, string memory _wikiPage)
        external
        returns (bool)
    {
        require(
            wikiPageExists(_wikiPage) && _newController != address(0),
            "wiki_page_does_not_exist"
        );
        setwikiPageController(_wikiPage, _newController);

        // checks if controller is set to new owner
        address newController = wikiPageController[_wikiPage];
        if (newController == _newController) {
            return true;
        }
        return false;
    }
}
