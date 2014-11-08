var DragAndDropDirective = angular.module('dnd', []);
DragAndDropDirective.directive('dndList', function() {
    return function(scope, element, attrs) {
        // variables used for dnd
        var toUpdate;
        var startIndex = -1;
        
        // watch the model, so we always know what element
        // is at a specific position
        scope.$watch(attrs.dndList, function(value) {
            toUpdate = value;
        },true);
        
        // use jquery to make the element sortable (dnd). This is called
        // when the element is rendered
        $(element[0]).sortable({
            items:'span',
            start:function (event, ui) {
                // on start we define where the item is dragged from
                startIndex = ($(ui.item).index());
            },
            stop:function (event, ui) {
                // on stop we determine the new index of the
                // item and store it there
                var newIndex = ($(ui.item).index());
                var toMove = toUpdate[startIndex];
                toUpdate.splice(startIndex,1);
                toUpdate.splice(newIndex,0,toMove);
                
                // we move items in the array, if we want
                // to trigger an update in angular use $apply()
                // since we're outside angulars lifecycle
                scope.$apply(scope.model);
            },
            axis:'x'
        })
    }
});

DragAndDropDirective.directive('dndTable', function() {
    return function(scope, element, attrs) {
        // variables used for dnd
        var toUpdate;
        var startIndex = -1;
        // watch the model, so we always know what element
        // is at a specific position
        scope.$watch(attrs.dndTable, function(value) {
            toUpdate = value;
        },true);
        
        // use jquery to make the element sortable (dnd). This is called
        // when the element is rendered
        $(element[0]).sortable({
            items:'tr',
            start:function (event, ui) {
                // on start we define where the item is dragged from
                startIndex = ($(ui.item).index());
            },
            stop:function (event, ui) {
                // on stop we determine the new index of the
                // item and store it there
                var newIndex = ($(ui.item).index());
                var toMove = toUpdate[startIndex];
                toUpdate.splice(startIndex,1);
                toUpdate.splice(newIndex,0,toMove);
                
                // we move items in the array, if we want
                // to trigger an update in angular use $apply()
                // since we're outside angulars lifecycle
                scope.$apply(scope.model);
            },
            axis:'y'
        })
    }
});
