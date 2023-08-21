// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
contract Tweeter{
    
    struct Tweet{
        uint id;
        address author;
        string content;
        uint creatorAt;
    }
    struct Message{
        uint id;
        string content;
        address from;
        address to;
        uint creatAt;
    }
    mapping(uint=>Tweet) public tweets;
    mapping(address=>uint[]) public tweetsOf;
    mapping(address=>Message[]) public conversations;
    mapping(address=>mapping(address=>bool)) public operators;
    mapping (address=>address[]) public following;

    uint nextId;
    uint nextMessageId;
    
    function _tweet(address _from, string memory _content) internal{//need require to check validation
        tweets[nextId] = Tweet(nextId, _from, _content, block.timestamp);
        nextId = nextId+1;
    }
    function _sendMessage(address _from, address _to, string memory _content) internal{
        conversations[_from].push(Message(nextMessageId, _content, _from , _to, block.timestamp));
        nextMessageId++;
    }
        
        //using polymorphism
    //tweeting 
    function tweet(string memory _content) public {//owner
        _tweet(msg.sender, _content);
    }
    function tweet(address _from, string memory _content) public{ //owner ==> address (access).
        _tweet(_from, _content);
    }


    // for sending message 
    function sendMessage(string memory _content, address _to) public {
        _sendMessage(msg.sender, _to, _content);
    }

    function sendMessage(address _from , address _to, string memory _content) public {
        _sendMessage(_from, _to, _content);
    }

    // for following 

    function follow(address _followed) public{
        following[msg.sender].push(_followed);
    }

    function allow(address _operator) public{
        operators[msg.sender][_operator] = true;
    }

    function disallow(address _operator) public{
        operators[msg.sender][_operator] = false;
    }

    // getting latest tweet
    function getLatestTweets(uint count) public view returns(Tweet[] memory){
        require(count>0 && count<=nextId, "Count is not proprer");
        Tweet[] memory _tweets = new Tweet[](count); // array length - count
        uint j;
        for(uint i = nextId - count; i<nextId; i++){
            Tweet storage _structure = tweets[i];
            _tweets[j] = Tweet(_structure.id,
                            _structure.author,
                            _structure.content,
                            _structure.creatorAt);

                            j= j+1;
        }
        return _tweets;

    }
    //get latest tweets of user

    function getlatestOfUser(address _user, uint count) public view returns(Tweet[] memory) {
        Tweet[] memory _tweets = new Tweet[](count); // new memory array whoose length is count
        //tweetsof[_user] is having all the id's of the users.
        uint[] memory ids = tweetsOf[_user]; //ids array


        require(count>0 && count <= ids.length, "count is not define");
          uint j;
        for(uint i = ids.length - count; i<ids.length; i++){
            Tweet storage _structure = tweets[ids[i]]; // i = 2 id[2] = 14 - tweets[15]
            _tweets[j] = Tweet(_structure.id,
                            _structure.author,
                            _structure.content,
                            _structure.creatorAt);

                            j= j+1;
        }
        return _tweets;
    }

     


}
 