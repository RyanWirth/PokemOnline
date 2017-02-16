using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace PokemOnline {
    public class Trainer : BasePlayer
    {
        public string Name;
        public string EncodedString;
        public string Type = "HERO_MALE";
        public string Direction = "down";
        public int Money = 0;
        public string UID;
        public string Pokemon1; // These Pokemon strings all store the most up-to-date encoded string of the Pokemon in the Trainer's party.
        public string Pokemon2;
        public string Pokemon3;
        public string Pokemon4;
        public string Pokemon5;
        public string Pokemon6;
        public int xPos = 1;
        public int yPos = 1;
        public int level = 0;
        public bool busy = false;
        public string map;
        public bool running = false;
        public string region;
        public DateTime lastChatMessage = DateTime.Now;
    }

	[RoomType("PokemOnline")]
	public class GameCode : Game<Trainer> {
		// This method is called when an instance of your the game is created
		public override void GameStarted() {
			// anything you write to the Console will show up in the 
			// output window of the development server
			Console.WriteLine("Game is started: " + RoomId);

			// This is how you setup a timer
			/*AddTimer(delegate {
				// code here will code every 100th millisecond (ten times a second)
			}, 100);
			
			// Debug Example:
			// Sometimes, it can be very usefull to have a graphical representation
			// of the state of your game.
			// An easy way to accomplish this is to setup a timer to update the
			// debug view every 250th second (4 times a second).
			AddTimer(delegate {
				// This will cause the GenerateDebugImage() method to be called
				// so you can draw a grapical version of the game state.
				RefreshDebugView(); 
			}, 250);*/
		}

		// This method is called when the last player leaves the room, and it's closed down.
		public override void GameClosed() {
			Console.WriteLine("RoomId: " + RoomId);
		}

		// This method is called whenever a player joins the game
		public override void UserJoined(Trainer player) {
            // this is how you send a player a message
            //player.Send("hello");

            string name;
            player.JoinData.TryGetValue("Name", out name);
            player.Name = name;

            foreach(Trainer otherPlayer in Players)
            {
                if(otherPlayer != player && otherPlayer.Name == player.Name)
                {
                    // Two players have the same name - reject the new one!
                    player.Send("ChatMessage", "WORLD", "SYSTEM", "SYSTEM", "Already logged in!");
                    player.Disconnect();
                    return;
                }
            }

            string encodedString;
            string type;
            string money;
            string uid;
            string pokemon1;
            string pokemon2;
            string pokemon3;
            string pokemon4;
            string pokemon5;
            string pokemon6;
            string xPos;
            string yPos;
            string map;
            string region;

            player.JoinData.TryGetValue("EncodedString", out encodedString);
            player.JoinData.TryGetValue("Type", out type);
            player.JoinData.TryGetValue("UID", out uid);
            player.JoinData.TryGetValue("Pokemon1", out pokemon1);
            player.JoinData.TryGetValue("Pokemon2", out pokemon2);
            player.JoinData.TryGetValue("Pokemon3", out pokemon3);
            player.JoinData.TryGetValue("Pokemon4", out pokemon4);
            player.JoinData.TryGetValue("Pokemon5", out pokemon5);
            player.JoinData.TryGetValue("Pokemon6", out pokemon6);
            player.JoinData.TryGetValue("map", out map);
            player.JoinData.TryGetValue("region", out region);
            player.JoinData.TryGetValue("Money", out money);
            player.JoinData.TryGetValue("xPos", out xPos);
            player.JoinData.TryGetValue("yPos", out yPos);

            player.EncodedString = encodedString;
            player.Type = type;
            player.Money = Convert.ToInt32(money);
            player.UID = uid;
            player.Pokemon1 = pokemon1;
            player.Pokemon2 = pokemon2;
            player.Pokemon3 = pokemon3;
            player.Pokemon4 = pokemon4;
            player.Pokemon5 = pokemon5;
            player.Pokemon6 = pokemon6;
            player.xPos = Convert.ToInt32(xPos);
            player.yPos = Convert.ToInt32(yPos);
            player.map = map;
            player.region = region;
            player.lastChatMessage = DateTime.Now;



            sendChatMessage(null, "WORLD", player.Name + " joined the Room.");

            makeLocalsAwareOfEachOther(player);

			// this is how you broadcast a message to all players connected to the game
			//Broadcast("UserJoined", player.Id);
		}

		// This method is called when a player leaves the game
		public override void UserLeft(Trainer player) {
            sendToLocal("ChangeMap", player, false, player.Name);
            sendChatMessage(null, "WORLD", player.Name + " left the Room.");
		}

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Trainer player, Message message) {
			switch(message.Type) {
				// This is how you would set a players name when they send in their name in a 
				// "MyNameIs" message
                case "UpdatePokemon":
                    int pokemonNum = message.GetInt(0);
                    string pokemonData = message.GetString(1);
                    if (pokemonNum == 1) player.Pokemon1 = pokemonData;
                    else if (pokemonNum == 2) player.Pokemon2 = pokemonData;
                    else if (pokemonNum == 3) player.Pokemon3 = pokemonData;
                    else if (pokemonNum == 4) player.Pokemon4 = pokemonData;
                    else if (pokemonNum == 5) player.Pokemon5 = pokemonData;
                    else if (pokemonNum == 6) player.Pokemon6 = pokemonData;
                    break;
                case "Location":
                    player.xPos = message.GetInt(0);
                    player.yPos = message.GetInt(1);
                    sendPlayerLocation(player);
                    break;
                case "LocationRegion":
                    player.region = message.GetString(0);
                    break;
                case "DirectionChange":
                    player.Direction = message.GetString(0);
                    sendToLocal("DirectionChange", player, false, player.Name, player.Direction);
                    break;
                case "PlayerRequest":
                    Trainer otherPlayer = player;
                    foreach(Trainer tempPlayer in Players)
                    {
                        if (tempPlayer.Name == message.GetString(0)) otherPlayer = tempPlayer;
                    }
                   sendPlayerRequest(player, otherPlayer);
                    break;
                case "ChangeMap":
                    sendToLocal("ChangeMap", player, false, player.Name);
                    player.map = message.GetString(0);
                    break;
                case "BusyState":
                    player.busy = message.GetBoolean(0);
                    sendToLocal("BusyState", player, false, player.Name, player.busy);
                    break;
                case "RunState":
                    player.running = message.GetBoolean(0);
                    sendToLocal("RunState", player, false, player.Name, player.running);
                    break;
                case "ChatMessage":
                    string scope = message.GetString(0);
                    string messageText = message.GetString(1);

                    // Flood protection - value: 1 second between messages.
                    if (DateTime.Now < player.lastChatMessage.AddSeconds(0.5))
                    {
                        // Flood protection on!
                        Console.WriteLine(player.Name + " is flooding the chat!");
                        player.Send("ChatMessage", scope, "SYSTEM", "SYSTEM", "Flood protection activated - message not sent.");
                    }
                    else sendChatMessage(player, scope, messageText);
                    player.lastChatMessage = DateTime.Now;
                    
                    break;
                case "RequestListOfPlayers":
                    userRequestedListOfPlayers(player, message.GetString(0));
                    break;
                case "ChatShout":
                    if(getPlayerPrivilege(player) == "ADMINISTRATOR")
                    {
                        Broadcast("ChatShout", getPlayerPrivilege(player), player.Name, message.GetString(0));
                    }
                    break;
			}
		}

		Point debugPoint;

		// This method get's called whenever you trigger it by calling the RefreshDebugView() method.
		public override System.Drawing.Image GenerateDebugImage() {
			// we'll just draw 400 by 400 pixels image with the current time, but you can
			// use this to visualize just about anything.
			var image = new Bitmap(400,400);
			using(var g = Graphics.FromImage(image)) {
				// fill the background
				g.FillRectangle(Brushes.Blue, 0, 0, image.Width, image.Height);

				// draw the current time
				g.DrawString(DateTime.Now.ToString(), new Font("Verdana",20F),Brushes.Orange, 10,10);

				// draw a dot based on the DebugPoint variable
				g.FillRectangle(Brushes.Red, debugPoint.X,debugPoint.Y,5,5);
			}
			return image;
		}

		// During development, it's very usefull to be able to cause certain events
		// to occur in your serverside code. If you create a public method with no
		// arguments and add a [DebugAction] attribute like we've down below, a button
		// will be added to the development server. 
		// Whenever you click the button, your code will run.
		[DebugAction("Play", DebugAction.Icon.Play)]
		public void PlayNow() {
			Console.WriteLine("The play button was clicked!");
		}

		// If you use the [DebugAction] attribute on a method with
		// two int arguments, the action will be triggered via the
		// debug view when you click the debug view on a running game.
		[DebugAction("Set Debug Point", DebugAction.Icon.Green)]
		public void SetDebugPoint(int x, int y) {
			debugPoint = new Point(x,y);
		}

        private void makeLocalsAwareOfEachOther(Trainer player)
        {
            sendPlayerLocation(player);

            // Find other players in the vicinity
            int dX;
            int dY;
            double dist;
            foreach (Trainer otherPlayer in Players)
            {
                dX = otherPlayer.xPos - player.xPos;
                dY = otherPlayer.yPos - player.yPos;
                dist = Math.Sqrt(dX * dX + dY * dY);
                if (dist <= 25) sendPlayerRequest(player, otherPlayer);
            }
        }

        private void sendPlayerRequest(Trainer player, Trainer otherPlayer)
        {
            if (player == otherPlayer) return;

            player.Send("PlayerRequest", otherPlayer.Name, otherPlayer.Type, otherPlayer.xPos, otherPlayer.yPos, otherPlayer.Direction, otherPlayer.running, otherPlayer.busy);
        }

        private void sendPlayerLocation(Trainer player)
        {
            sendToLocal("Location", player, false, player.xPos, player.yPos, player.Name);
        }

        private void userRequestedListOfPlayers(Trainer player, string scope)
        {
            string playerlist = "";
            if(scope == "WORLD")
            {
                // Player wants to know about every player.
                foreach (Trainer otherPlayer in Players) playerlist += otherPlayer.Name + ", ";
            } else
            if(scope == "REGION")
            {
                foreach(Trainer otherplayer in Players)
                {
                    if (otherplayer.region == player.region) playerlist += otherplayer.Name + ", ";
                }
            } else
            if(scope == "LOCAL")
            {
                double dX;
                double dY;
                double dist;
                foreach(Trainer otherplayer1 in Players)
                {
                    dX = otherplayer1.xPos - player.xPos;
                    dY = otherplayer1.yPos - player.yPos;
                    dist = Math.Sqrt(dX * dX + dY * dY);
                    if (dist <= 25) playerlist += otherplayer1.Name + ", ";
                }
            }
            playerlist = playerlist.Substring(0, playerlist.Length - 2);
            playerlist += ".";
            player.Send("ChatMessage", scope, "SYSTEM", "SYSTEM", "Players in scope:\n" + playerlist);
        }

        private string getPlayerPrivilege(Trainer player)
        {
            switch(player.Name)
            {
                case "Rye":
                case "PROWNE":
                    return "ADMINISTRATOR";
                default:
                    return "REGULAR";
            }
        }

        private void sendChatMessage(Trainer player, string scope, string messageText)
        {
            if (player == null)
            {
                Broadcast("ChatMessage", "WORLD", "SYSTEM", "SYSTEM", messageText);
                return;
            }

            // This is where we would determine what permissions the user has
            string style = getPlayerPrivilege(player);

            if (scope == "WORLD") Broadcast("ChatMessage", scope, style, player.Name, messageText);
            else if (scope == "REGION")
            {
                foreach (Trainer otherPlayer in Players)
                {
                    if (otherPlayer.region == player.region && otherPlayer.map == player.map) otherPlayer.Send("ChatMessage", scope, style, player.Name, messageText);
                }
            }
            else if (scope == "LOCAL")
            {
                sendToLocal("ChatMessage", player, true, scope, style, player.Name, messageText);
            }

            Console.WriteLine("ChatMessage:<" + (player != null ? player.Name : "SYSTEM") + "> (" + scope + ") " + messageText);
        }

        private void sendToLocal(string MessageType, Trainer sourcePlayer, bool sendToSelf, params object[] parameters)
        {
            foreach (Trainer otherPlayer in Players)
            {
                if (otherPlayer.map != sourcePlayer.map) continue;
                if (sendToSelf == false && otherPlayer == sourcePlayer) continue;
                double dX = otherPlayer.xPos - sourcePlayer.xPos;
                double dY = otherPlayer.yPos - sourcePlayer.yPos;
                double dist = Math.Sqrt(dX * dX + dY * dY);
                if (dist <= 25) otherPlayer.Send(MessageType, parameters);
            }
        }
    }
}
