import * as PushAPI from "@pushprotocol/restapi";

// package to fetch all the notifications from an address on a specific chain.
const fetchNotifs =   async() => {
    const notifications = await PushAPI.user.getFeeds({
        user: 'eip155:42:0xD8634C39BBFd4033c0d3289C4515275102423681', // user address in CAIP-10
        env: 'staging'
    });

    console.log('Notifications: \n', notifications);
}

fetchNotifs();