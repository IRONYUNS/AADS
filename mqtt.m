function obj = mqtt(varargin)
 % MQTT Create a MQTT connection to an MQTT broker.
    % 
    %
    % Syntax 
    % ------ 
    % mObj = mqtt(brokerAddress) creates a new MQTT
    % connection to a broker at BrokerAddress
    %
    % mObj = mqtt(brokerAddress, NAME, VALUE) uses additional options
    % specified by one or more Name, Value pair arguments.
    %
    % Inputs 
    % ------ 
    % BrokerAddress:  Host name or IP address of the MQTT broker, 
    % specified as a string or character array including connection
    % protocol. Supported protocols include TCP, WS, SSL, and WSS.
    %
    %   Name-Value Pair Arguments
    %   -------------------------
    %
    %   Name         Description                             Data Type
    %   ----    --------------------                         ---------
    %
    %   Port                                                Integer
    %           Specify the socket port number to 
    %           use when connecting to the MQTT broker.
    %
    %   Username                                            string, char
    %           Specify username to use when connecting
    %           to the MQTT broker.
    %
    %   Password                                            string, char
    %           Specify password to use with the username
    %           used for connecting to MQTT broker.
    %
    %   ClientID                                            string, char
    %           Specify an MQTT identifier that identifies
    %           the client to the broker. 
    %
    %   Timeout                                             Integer
    %           Specify time in seconds to complete a
    %           connection to the broker.
    %
    %   CAFile                                              string, char
    %           Specify Server Root Certificate to use
    %           for authenticating the broker during
    %           secure connection.
    %
    %   ClientCertificate                                   string, char
    %           Specify Client Certificate to use for
    %           authenticating client during secure 
    %           connection.
    %
    %   ClientKeyFile                                       string, char
    %           Specify private key file to use along
    %           with ClientCertificate for client 
    %           authentication during secure connection.
    %
    %   SSLPassword                                         string, char
    %           Specify password to decrypt the private
    %           key in ClientKeyFile.    
    %
    %   Examples:
    %   --------
    %
    %     Connect to broker
    %     -------------------------------    
    %
    %     % Example 1: Connect to broker
    %     % ----------
    %     % Create an MQTT connection to hivemq public broker.
    %     myMQTT = mqtt('tcp://broker.hivemq.com')
    %
    %     % Example 2: Create an MQTT connection with ClientID and Port
    %     Number 
    %     %  ---------- 
    %     % Create an MQTT connection to hivemq public broker at port 
    %     % number 1883 and specify the clientID as 'myClient'
    %     myMQTT = mqtt('tcp://broker.hivemq.com','ClientID','myClient',...
    %       'Port',1883)
    %
    %     % Example 3: Create a secure MQTT connection over TCP
    %     %  ---------- 
    %     % Create an MQTT connection to mosquitto public broker at port 
    %     % number 8884 and specify the broker root certificate, client
    %     % certificate and private key.
    %     myMQTTSSL = mqtt('ssl://mosquitto.org', 'Port', 8884, ...
    %       'CAFile', 'C:.\mosquitto.org.pem',...
    %       'ClientCertificate', 'C:.\client.pem',...
    %       'ClientKeyFile', 'C:.\client.key')
    %
    %     % Example 4: Create a secure MQTT connection over WS
    %     %  ---------- 
    %     % Create an MQTT connection with WSS to ThingSpeak. If required,
    %     % you can specify the required certificates and keys using 
    %     % Name-Value input arguments.
    %     myMQTT = mqtt('wss://mqtt.thingspeak.com', 'Port', 443)  
    %
    %     % Example 5: Subscribe to topic
    %     %  ---------- 
    %     % Create an MQTT connection to hivemq public broker and 
    %     % subscribe to 'myTopic'.
    %     myMQTT = mqtt('tcp://broker.hivemq.com');
    %
    %     %Subscribe to a topic
    %     mySub = subscribe(myMQTT,'Topic')
    %
    %     % Example 6: Subscribe to topic at QoS 2
    %     %  ---------- 
    %     % Create an MQTT connection to hivemq public broker and 
    %     % subscribe to 'myTopic'.
    %     myMQTT = mqtt('tcp://broker.hivemq.com');
    %
    %     %Subscribe to a topic
    %     mySub = subscribe(myMQTT,'Topic', 'QoS', 2);
    %
    %     % Example 7: Publish to topic 
    %     %  ---------- 
    %     % Create an MQTT connection to hivemq public broker and 
    %     % publish message 'testMessage' to topic 'myTopic'.
    %     myMQTT = mqtt('tcp://broker.hivemq.com');
    %
    %     % Publish a message to a topic
    %     publish(myMQTT, 'myTopic', 'testMessage');    
        
    % Copyright 2017-2019, The MathWorks, Inc.
    