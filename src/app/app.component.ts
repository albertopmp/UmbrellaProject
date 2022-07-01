import { BreakpointObserver } from '@angular/cdk/layout';
import { ChangeDetectorRef, Component, ViewChild } from '@angular/core';
import { MatSidenav } from '@angular/material/sidenav';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  hasBackdrop = false;
  hideBadge = false;

  @ViewChild(MatSidenav)
  sidenav!: MatSidenav;

  constructor(private observer: BreakpointObserver, private chgDetect: ChangeDetectorRef) {}

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

  toggleBadgeVisibility() {
    this.hideBadge = true;
  }
}
