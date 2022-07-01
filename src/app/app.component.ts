import { BreakpointObserver } from '@angular/cdk/layout';
import { ChangeDetectorRef, Component, ViewChild } from '@angular/core';
import { MatSidenav } from '@angular/material/sidenav';
import { NavigationStart, Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  hasBackdrop = false;
  hideBadge = false;

  routerEvents$;
  currentRoute = '';

  @ViewChild(MatSidenav)
  sidenav!: MatSidenav;

  constructor(private router: Router, private observer: BreakpointObserver, private chgDetect: ChangeDetectorRef) {
    this.routerEvents$ = this.router.events.subscribe((event) => {
      if (event instanceof NavigationStart) {
        this.currentRoute = event.url;
      }
    });
  }

  ngAfterViewInit() {
    this.observer.observe(['(max-width: 800px)']).subscribe((res) => {
      if (res.matches) {
        this.hasBackdrop = true;
        this.sidenav.mode = 'over';
        this.sidenav.close();
      } else {
        this.hasBackdrop = false;
        this.sidenav.mode = 'side';
        this.sidenav.open();
      }
      this.chgDetect.detectChanges();
    });
  }

  ngOnDestroy() {
    this.routerEvents$.unsubscribe();
  }

  toggleBadgeVisibility() {
    this.hideBadge = true;
  }
}
