from django.shortcuts import render
from django.views import View

class HomeView(View):
    def get(self, request, *args, **ksargs):
        return render(request, 'app/home.html')
