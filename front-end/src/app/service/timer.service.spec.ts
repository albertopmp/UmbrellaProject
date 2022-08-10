import { fakeAsync, TestBed, tick } from '@angular/core/testing';
import { TimerService } from './timer.service';

class Dummy {
  testFunction = () => {};
}

describe('TimerService', () => {
  let service: TimerService;
  let dummy: Dummy;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TimerService);
    dummy = new Dummy();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should check timer', fakeAsync(() => {
    const spy = spyOn(dummy, 'testFunction');
    expect(spy).toHaveBeenCalledTimes(0);
    const timer = service.timer(0, 1000).subscribe(() => dummy.testFunction());
    tick(0);
    expect(spy).toHaveBeenCalledTimes(1);
    tick(999);
    expect(spy).toHaveBeenCalledTimes(1);
    tick(1);
    expect(spy).toHaveBeenCalledTimes(2);
    timer.unsubscribe();
  }));
});
