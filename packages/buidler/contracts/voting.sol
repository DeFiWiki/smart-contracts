// //////////////////////////// Voting Logic ////////////////////////////////

// // Vote for Artists
//     function vote(uint256 _artist) public {
//         UserInfo storage user = userInfo[0][msg.sender];

//         uint votes = user.amount;

//         require(artistInfo[_artist].artistActive == true, "Artist Not Active");

//          if(user.lastVote < artistInfo[0].lastReset) {
//             user.votes = 0;
//         }

//         if(user.amount > user.votes && user.hasVoted == true) {

//             artistInfo[_artist].artistVotes -= user.votes;
//             artistInfo[_artist].artistVotes += user.amount;

//             user.lastVote = now;
//             user.votedFor = _artist;
//             user.hasVoted = true;
//             user.votes = votes;
//         }

//         else {
//            require(user.amount > user.votes, "Already voted / Out of Votes");

//             artistInfo[_artist].artistVotes += user.amount;

//             user.lastVote = now;
//             user.votedFor = _artist;
//             user.hasVoted = true;
//             user.votes = votes;
//         }

//     emit Vote(msg.sender, _artist, votes);
//     }

// // Unvote for Artists
//     function unVote() nonReentrant public {
//         UserInfo storage user = userInfo[0][msg.sender];
//         uint votes = user.votes;
//         uint256 artist = user.votedFor;

//         if(user.lastVote < artistInfo[0].lastReset) {
//             user.votes = 0;
//             user.hasVoted = false;
//         }

//         require(user.hasVoted == true, "Have to Vote First");

//         artistInfo[artist].artistVotes -= votes;

//         user.hasVoted = false;
//         user.votes -= votes;
//         user.votedFor = 0;

//     emit UnVote(msg.sender, artist, votes);
//     }

// }
// / Info of each user.
//     struct UserInfo {
//         uint256 amount;         // How many LP tokens the user has provided.
//         uint256 deposited;      // How much they've deposited.
//         uint256 userMax;        // User's Maximum Multiplier.
//         uint256 historic;       // Record of User's purchased Multipliers.
//         uint256 votes;          // Last Vote Amount.
//         uint256 lastVote;       // Record of the last time the user voted.
//         uint256 votedFor;       // Artist the user voted for.
//         bool hasVoted;          // Check to see if voted.
// // Info of Artist NFTs.
//     struct ArtistInfo {
//         uint256 artistID;       // Artist ID (Mostly for Frontend).
//         string artistName;      // Name of Artist.
//         address artistAddress;  // Address of the artist.
//         uint256 artistVotes;    // Number of votes received.
//         bool artistActive;      // Mark if the artist is active any given week.
//         uint256 lastReset;      // Record of when the last snapshot and reset was done.
//     }
// // Snapshot Info
//     struct Snapshot {
//         uint256[] artistID;      // Artist IDs.
//         string[] artistName;     // Names of Artist.
//         address[] artistAddress; // Addresses of the artists.
//         uint256[] artistVotes;   // Number of votes the artists have.
//     }
// // Take Snapshot for the week
//     function snapshot() external onlyOwner {
//         Snapshot memory newSnapshotData;


//         uint[] memory ID = new uint[](artistInfo.length);
//         string[] memory Name = new string[](artistInfo.length);
//         address[] memory artistAddress = new address[](artistInfo.length);
//         uint[] memory Votes = new uint[](artistInfo.length);

//         for (uint256 i = 0; i < artistInfo.length; i++) {

//         ID[i] = artistInfo[i].artistID;
//         Name[i] = artistInfo[i].artistName;
//         artistAddress[i] = artistInfo[i].artistAddress;
//         Votes[i] = artistInfo[i].artistVotes; 

//         newSnapshotData.artistID = ID;
//         newSnapshotData.artistName = Name;
//         newSnapshotData.artistAddress = artistAddress;
//         newSnapshotData.artistVotes = Votes;
//         }

//             snapshotData.push(newSnapshotData);

//         resetAllVotes();

//     }