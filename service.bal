import ballerinax/github;
import ballerina/http;

configurable string accessToken = ?;
# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + return - string name with hello message or error
    resource function get moststars/[string org]() returns string[]|error {
        // Send a response back to the caller.
        github:Client githubEp = check new (config = {
            auth: {
                token: accessToken
            }
        });
        stream<github:Repository, error?> getRepositoriesResponse = check githubEp->getRepositories();
        string[]? repositories =  check from github:Repository repo in getRepositoriesResponse
                                            order by repo.stargazerCount
                                            limit 5
                                            select repo.name;

       return repositories ?:[];
    }
}
