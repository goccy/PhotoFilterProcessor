var PhotoFilterProcessor = angular.module('PhotoFilterProcessor', ['ui.bootstrap']);

PhotoFilterProcessor.run(function($http) {
    $http.defaults.headers.post = {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };
});

PhotoFilterProcessor.config(function ($httpProvider) {
    $httpProvider.defaults.transformRequest = function(data){
        if (data === undefined) {
            return data;
        }
        return $.param(data);
    }
});

PhotoFilterProcessor.controller('FilterController', ['$http', '$scope', '$modal', function($http, $scope, $modal) {

    $http.get('/filters').success(function(filters) {
        $scope.filters = filters;
    });

    $scope.download = function() {
        var download_filter_names = $scope.filters.filter(function(filter) {
            return filter.can_download;
        }).map(function(download_filter) {
            return download_filter.name;
        });
        $http.post('/download', { download_filter_names : download_filter_names }).success(function(zip) {
            var download_elem = document.createElement('a');
            download_elem.href   = zip.path;
            download_elem.target = '_blank';
            download_elem.download = zip.name;
            download_elem.click();
        }).error(function() {
            alert("Failed creating archive");
        });
    };

    $scope.remove = function() {
        var delete_filter_names = $scope.filters.filter(function(filter) {
            return filter.can_remove;
        }).map(function(delete_filter) {
            return delete_filter.name;
        });
        console.log(delete_filter_names);
        $http.post('/delete', { delete_filter_names : delete_filter_names }).success(function() {
            $scope.filters = $scope.filters.filter(function(filter) {
                return filter.can_remove;
            });
        }).error(function() {
            alert("Failed deleting filter");
        });
    };

}]);
